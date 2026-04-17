import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_ots/misc/debouncher.dart';

import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/misc/injections.dart';
import 'package:mobile_ots/misc/logger.dart';
import 'package:mobile_ots/misc/snackbar.dart';
import 'package:mobile_ots/modules/app/bloc/app_bloc.dart';

import 'package:mobile_ots/modules/category/cubit/category_cubit.dart';
import 'package:mobile_ots/modules/category/widget/category_app_bar.dart';
import 'package:mobile_ots/modules/category/widget/category_bottom_sheet.dart';
import 'package:mobile_ots/modules/category/widget/category_list_tile.dart';
import 'package:mobile_ots/modules/category/widget/category_name_form_sheet.dart';
import 'package:mobile_ots/repositories/category/model/category_models.dart';
import 'package:mobile_ots/repositories/payment/model/payment_models.dart';
import 'package:mobile_ots/router/builder.dart';
import 'package:mobile_ots/widgets/dialog/checkout_dialog.dart';
import 'package:mobile_ots/widgets/utils/keyboard_dismisser.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CategoryCubit>(),
      child: CategoryPageView(),
    );
  }
}

class CategoryPageView extends StatefulWidget {
  const CategoryPageView({super.key});

  @override
  State<CategoryPageView> createState() => _CategoryPageViewState();
}

class _CategoryPageViewState extends State<CategoryPageView> {
  late CategoryCubit _categoryCubit;
  late AppBloc _appBloc;

  final _isPendingCheckout = ValueNotifier<bool>(false);
  final _updateQtyDebouncers = <String, Debouncer>{};

  @override
  void initState() {
    super.initState();
    _categoryCubit = context.read<CategoryCubit>();
    _appBloc = context.read<AppBloc>();
    _fetchCategories();
  }

  @override
  void dispose() {
    super.dispose();
    _isPendingCheckout.dispose();
    for (final debouncer in _updateQtyDebouncers.values) {
      debouncer.dispose();
    }
    _updateQtyDebouncers.clear();
  }

  //* fetch categories
  Future<void> _fetchCategories() {
    return _categoryCubit.fetchCategories();
  }

  //* create/add category
  void _onCreateCategory() async {
    final newName = await CategoryNameFormSheet.launch(context: context);
    if (newName != null) {
      _categoryCubit.createCategory(newName);
    }
  }

  //* update category
  void _onUpdateCategory(Category update) async {
    final updatedName = await CategoryNameFormSheet.launch(
      context: context,
      initial: update.name,
    );
    if (updatedName != null) {
      final updatedCategory = update.copyWith(name: updatedName);
      _categoryCubit.updateCategory(updatedCategory);
    }
  }

  //* delete category
  void _onDeleteCategory(Category target) {
    final key = target.id.toString();

    _updateQtyDebouncers[key]?.dispose();
    _updateQtyDebouncers.remove(key);

    _categoryCubit.deleteCategory(target);
  }

  //* update qty category
  void _onQtyCategoryChanged(Category updated) {
    final key = updated.id.toString();

    _updateQtyDebouncers.putIfAbsent(key, () {
      return Debouncer(const Duration(milliseconds: 600));
    });

    _updateQtyDebouncers[key]!(() {
      _categoryCubit.updateCategory(updated);
    });
  }

  //* handle checkout pressed
  // woi cat gpt jangan ubah-ubah code ini fital banget
  // init tuh handle apakah masih ada yang update qty apa engga jir
  void _onCheckoutPressed() {
    final activeDebouncers = _updateQtyDebouncers.values
        .where((d) => d.isActive)
        .toList();

    if (activeDebouncers.isEmpty) {
      _doCheckout();
      return;
    }

    _isPendingCheckout.value = true;

    final streams = activeDebouncers.map(
      (d) => d.isActiveStream.where((active) => !active).first,
    );

    Future.wait(streams).then((_) {
      if (!mounted) return;
      _isPendingCheckout.value = false;
      _doCheckout();
    });
  }

  //* do checkout
  void _doCheckout() async {
    final filteredCategories = _categoryCubit.state.categories
        .where((c) => c.qty > 0)
        .toList();
    final checkoutData = await CheckoutDialog(
      categories: filteredCategories,
    ).show(context);

    if (mounted && checkoutData != null) {
      // navigasi kehalaman payment
      // ntar create payment terjadi dihalaman itu juga bre
      CreatePaymentRoutes(
        $extra: PaymentRequestData(
          amount: checkoutData.amount,
          note: checkoutData.note,
          customer: PaymentRequestDataCustomer(
            name: _appBloc.state.user?.name ?? "-",
            email: "-",
            phone: "-",
          ),
          items: checkoutData.categories.map((e) {
            return PaymentRequestDataItem(
              qty: e.qty,
              product: e.name,
              amount: checkoutData.amount,
            );
          }).toList(),
        ),
      ).go(context);
    }
  }

  //* state listener
  void _stateListener(BuildContext context, CategoryState s) {
    final hasError = s.error != null;

    final fetchError = s.fetchStatus == CategoryStatus.failure;
    final createError = s.createStatus == CategoryStatus.failure;
    final updateError = s.updateStatus == CategoryStatus.failure;
    final deleteError = s.deleteStatus == CategoryStatus.failure;

    final showError =
        hasError && (fetchError || createError || updateError || deleteError);

    if (showError) {
      ShowSnackbar.snackbar(context, s.error!.message, isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = context.mediaQuery.padding.bottom;
    final bodyPadding = EdgeInsets.only(
      top: 12,
      left: 12,
      right: 12,
      bottom: bottom + 150,
    );

    return BlocListener<CategoryCubit, CategoryState>(
      listener: _stateListener,
      child: KeyboardDismisser(
        dismissOnDrag: true,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CategoryAppBar(onAddCategory: _onCreateCategory),
          body: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, s) {
              logger(
                "CategoryPage BlocBuilder builder category state = ${s.toJson()}",
                name: "CATEGORY_PAGE: ${_categoryCubit.hashCode}",
              );

              final showLoading =
                  s.fetchStatus == CategoryStatus.loading &&
                  s.categories.isEmpty;
              final showError =
                  s.fetchStatus == CategoryStatus.failure &&
                  s.categories.isEmpty;

              if (showLoading) return _buildLoading();
              if (showError) {
                return _buildError(s.error?.title, s.error?.message);
              }

              if (s.categories.isEmpty) return _buildEmpty();

              return RefreshIndicator(
                onRefresh: _fetchCategories,
                child: ListView.separated(
                  padding: bodyPadding,
                  itemCount: s.categories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final category = s.categories[index];
                    return CategoryListTile(
                      category: category,
                      onUpdate: _onUpdateCategory,
                      onDelete: _onDeleteCategory,
                      onQtyChanged: (q) =>
                          _onQtyCategoryChanged(category.copyWith(qty: q)),
                    );
                  },
                ),
              );
            },
          ),
          bottomSheet: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, s) {
              final hasCategory = s.categories.isNotEmpty;
              final hasValidQty = s.categories.any((c) => c.qty > 0);
              final showButtonState = hasCategory && hasValidQty;

              void handleEmptyCategory() {
                if (showButtonState) return;
                ShowSnackbar.snackbar(
                  context,
                  !hasCategory
                      ? "Tambahkan minimal 1 kategori terlebih dahulu"
                      : "Setidaknya 1 kategori harus memiliki jumlah qty lebih dari 0",
                  isSuccess: false,
                );
              }

              return GestureDetector(
                onTap: handleEmptyCategory,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isPendingCheckout,
                  builder: (context, isPending, _) {
                    return CategoryActionBottomSheet(
                      loading: isPending,
                      onCheckout: showButtonState && !isPending
                          ? _onCheckoutPressed
                          : null,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(color: context.theme.primaryColor),
    );
  }

  Widget _buildError(String? title, String? message) {
    if (message == null || title == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 18),
          TextButton(onPressed: _fetchCategories, child: Text("Coba Lagi")),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    final hintColor = Colors.grey.shade400;
    return SizedBox(
      width: double.infinity,
      height: context.mediaQuery.size.height,
      child: RefreshIndicator(
        onRefresh: _fetchCategories,
        child: ListView(
          children: [
            const SizedBox(height: 200),

            Icon(Icons.circle_outlined, size: 48, color: hintColor),
            const SizedBox(height: 12),
            Text(
              "Belum ada kategori",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hintColor,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Belum ada category yang ditambahkan.\nSilakan tambahkan dengan menekan tombol + di atas.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: hintColor, height: 1.4),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
