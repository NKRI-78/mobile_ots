import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_ots/misc/debouncher.dart';

import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/misc/injections.dart';
import 'package:mobile_ots/misc/snackbar.dart';

import 'package:mobile_ots/modules/category/cubit/category_cubit.dart';
import 'package:mobile_ots/modules/category/widget/category_app_bar.dart';
import 'package:mobile_ots/modules/category/widget/category_bottom_sheet.dart';
import 'package:mobile_ots/modules/category/widget/category_list_tile.dart';
import 'package:mobile_ots/modules/category/widget/category_name_form_sheet.dart';
import 'package:mobile_ots/modules/category/widget/custom_drawer.dart';
import 'package:mobile_ots/repositories/category/model/category_models.dart';
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

  final _isPendingCheckout = ValueNotifier<bool>(false);
  final _updateQtyDebouncher = Debouncer(const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    _categoryCubit = context.read<CategoryCubit>();
    _fetchCategories();
  }

  @override
  void dispose() {
    super.dispose();
    _isPendingCheckout.dispose();
    _updateQtyDebouncher.dispose();
  }

  Future<void> _fetchCategories() {
    return _categoryCubit.fetchCategories();
  }

  void _onAddCategory() async {
    final newName = await CategoryNameFormSheet.launch(context: context);
    if (newName != null) {
      _categoryCubit.createCategory(Category(id: 0, name: newName));
    }
  }

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

  void _onDeleteCategory(Category target) {
    return _categoryCubit.deleteCategory(target);
  }

  void _onQtyCategoryChanged(Category updated) {
    _updateQtyDebouncher(() {
      _categoryCubit.updateCategory(updated);
    });
  }

  void _onCheckoutPressed() {
    if (_updateQtyDebouncher.isActive) {
      _isPendingCheckout.value = true;

      _updateQtyDebouncher.isActiveStream
          .where((isActive) => !isActive)
          .first
          .then((_) {
            if (!mounted) return;
            _isPendingCheckout.value = false;
            _doCheckout();
          });
    } else {
      _doCheckout();
    }
  }

  void _doCheckout() async {
    final filteredCategories = _categoryCubit.state.categories
        .where((c) => c.qty > 0)
        .toList();
    final checkoutData = await CheckoutDialog(
      categories: filteredCategories,
    ).show(context);

    if (checkoutData != null) {}
  }

  void _stateListener(BuildContext context, CategoryState s) {
    final hasError = s.error != null;

    final showFetchError = s.fetchStatus == CategoryStatus.failure;
    final showCreateError = s.createStatus == CategoryStatus.failure;
    final showUpdateError = s.updateStatus == CategoryStatus.failure;
    final showDeleteError = s.deleteStatus == CategoryStatus.failure;

    final showError =
        hasError &&
        (showFetchError ||
            showCreateError ||
            showUpdateError ||
            showDeleteError);

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
          appBar: CategoryAppBar(onAddCategory: _onAddCategory),
          drawer: Drawer(child: SafeArea(child: CustomDrawer())),
          body: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, s) {
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
          bottomSheet: BlocSelector<CategoryCubit, CategoryState, bool>(
            selector: (s) => s.categories.isNotEmpty,
            builder: (context, hasCategory) {
              void handleEmptyCategory() {
                if (hasCategory) return;
                ShowSnackbar.snackbar(
                  context,
                  "Tambahkan kategori terlebih dahulu",
                  isSuccess: false,
                );
              }

              return GestureDetector(
                onTap: handleEmptyCategory,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isPendingCheckout,
                  builder: (context, isPending, _) {
                    return CategoryActionBottomSheet(
                      onCheckout: hasCategory && !isPending
                          ? _onCheckoutPressed
                          : null,
                      loading: isPending,
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
