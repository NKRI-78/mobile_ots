import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/misc/request_status.dart';
import 'package:mobile_ots/modules/transaction/cubit/transaction_cubit.dart';
import 'package:mobile_ots/modules/transaction/widget/transaction_list_tile.dart';
import 'package:mobile_ots/widgets/appbar/custom_app_bar.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late final ScrollController _scrollController;

  late TransactionCubit _transactionCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _transactionCubit = context.read<TransactionCubit>();
    _fetchTransactions();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _fetchTransactions() async {
    await _transactionCubit.getTransactions();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _transactionCubit.loadMoreTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = context.mediaQuery.padding.bottom;
    final bodyPadding = EdgeInsets.only(
      top: 16,
      left: 6,
      right: 6,
      bottom: bottom + 16,
    );

    return Scaffold(
      appBar: CustomAppBar(titleText: "Riwayat Transaksi"),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, s) {
          final hasTransactions = s.transactions.isNotEmpty;
          final showLoading =
              s.transactionsStatus == RequestStatus.loading && !hasTransactions;
          final showError =
              s.transactionsStatus == RequestStatus.error && s.error != null;

          if (showLoading) return _buildLoading();
          if (showError) return _buildError(s.error!);
          if (!hasTransactions) return _buildEmpty();

          return RefreshIndicator(
            onRefresh: _fetchTransactions,
            child: ListView.separated(
              controller: _scrollController,
              padding: bodyPadding,
              itemCount: s.transactions.length + 1,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                if (index == s.transactions.length) {
                  return _buildPaginationFooter(s);
                }
                final transaction = s.transactions[index];
                return TransactionListTile(transaction);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(color: context.theme.primaryColor),
    );
  }

  Widget _buildEmpty() {
    return RefreshIndicator(
      onRefresh: _fetchTransactions,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: const [
          SizedBox(height: 120),
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
    );
  }

  Widget _buildError(AppError error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
