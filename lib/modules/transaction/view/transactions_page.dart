import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/misc/request_status.dart';
import 'package:mobile_ots/modules/category/cubit/category_cubit.dart';
import 'package:mobile_ots/modules/category/widget/custom_drawer.dart';
import 'package:mobile_ots/modules/transaction/cubit/transaction_cubit.dart';
import 'package:mobile_ots/modules/transaction/widget/label_sort_bar.dart';
import 'package:mobile_ots/modules/transaction/widget/sorting_dialog_sheet.dart';
import 'package:mobile_ots/modules/transaction/widget/profit_card.dart';
import 'package:mobile_ots/modules/transaction/widget/transaction_app_bar.dart';
import 'package:mobile_ots/modules/transaction/widget/transaction_list_tile.dart';
import 'package:mobile_ots/router/builder.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late final ScrollController _scrollController;

  late TransactionCubit _transactionCubit;
  late CategoryCubit _categoryCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _transactionCubit = context.read<TransactionCubit>();
    _categoryCubit = context.read<CategoryCubit>();
    _fetchTransactions();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  //* fetch transactions
  Future<void> _fetchTransactions() async {
    _transactionCubit.markSortMode(SortMode.newest);
    await _transactionCubit.getTransactions();
  }

  //* handle pagination on scroll
  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _transactionCubit.loadMoreTransactions(
        sort: _transactionCubit.state.sortMode.name,
      );
    }
  }

  //* handle sorting transactions
  void _onSortingPressed() async {
    final sortedResult = await SortingDialogSheet.launch(context);
    if (sortedResult != null) {
      _transactionCubit.markSortMode(sortedResult);
      await _transactionCubit.getTransactions(sort: sortedResult.name);
    }
  }

  //* on navigate to category page
  // jadi setiap kehalaman category itu harus reset
  // sementara reset semua qty itu hit api
  // maka handle reset semua qty terjadi disini juga
  // kalau di halaman category nanti kena race condition == bug
  void _onNavigateToCategoryPage() async {
    if (_categoryCubit.state.isResettingQty) return;
    await _categoryCubit.resetAllQty();
    if (mounted) CategoryRoutes().go(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = context.mediaQuery.padding.bottom;
    return Scaffold(
      drawer: CustomDrawer(),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, s) {
          return RefreshIndicator(
            onRefresh: _fetchTransactions,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                //! appbar
                SliverTransactionAppBar(),

                //! profit card
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                    bottom: 0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: ProfitCard(amount: s.totalAmount),
                  ),
                ),

                //! label "semua transaksi"
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 0,
                    top: 24,
                    right: 0,
                    bottom: 0,
                  ),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyFilterHeaderDelegate(
                      minHeight: 45,
                      maxHeight: 45,
                      child: LabelSortBar(
                        height: 45,
                        onSortingPressed: _onSortingPressed,
                      ),
                    ),
                  ),
                ),

                //! transactions state: loading, error, empty, loaded
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: 16,
                    top: 8,
                    right: 16,
                    bottom: bottom + kBottomNavigationBarHeight,
                  ),
                  sliver: _buildTransactionSliver(s),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: BlocSelector<CategoryCubit, CategoryState, bool>(
        selector: (s) => s.isResettingQty,
        builder: (context, isResettingQty) {
          return FloatingActionButton(
            onPressed: _onNavigateToCategoryPage,
            backgroundColor: context.theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: isResettingQty
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Icon(Icons.qr_code),
          );
        },
      ),
    );
  }

  Widget _buildTransactionSliver(TransactionState s) {
    final hasTransactions = s.transactions.isNotEmpty;
    final showLoading = s.transactionsStatus == RequestStatus.loading;
    final showError =
        s.transactionsStatus == RequestStatus.error && s.error != null;

    if (showLoading) return _buildLoading();
    if (showError) return _buildError(s.error!);
    if (!hasTransactions) return _buildEmpty();

    return DecoratedSliver(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == s.transactions.length) {
              return _buildPaginationFooter(s);
            }
            final transaction = s.transactions[index];
            return TransactionListTile(transaction);
          }, childCount: s.transactions.length + 1),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return SliverToBoxAdapter(
      child: Container(
        height: 400,
        width: double.infinity,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: context.theme.primaryColor),
      ),
    );
  }

  Widget _buildEmpty() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Belum ada transaksi",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "Transaksi yang kamu lakukan akan muncul di sini.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(AppError error) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),

          Text(
            error.title?.isNotEmpty == true
                ? error.title!
                : "Terjadi Kesalahan",
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(error.message, textAlign: TextAlign.center),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _fetchTransactions,
              child: const Text("Coba Lagi"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(TransactionState s) {
    if (s.isFetchingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: CircularProgressIndicator(color: context.theme.primaryColor),
        ),
      );
    }
    if (!s.hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'Semua transaksi sudah ditampilkan',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return const SizedBox(height: 60);
  }
}

class _StickyFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyFilterHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child); // penting
  }

  @override
  bool shouldRebuild(covariant _StickyFilterHeaderDelegate oldDelegate) {
    return false;
  }
}
