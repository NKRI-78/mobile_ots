import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import 'package:uuid/uuid.dart';

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

  @override
  void initState() {
    super.initState();
    _categoryCubit = context.read<CategoryCubit>();
    _categoryCubit.fetchCategories();
  }

  void _onAddCategory() async {
    final newName = await CategoryNameFormSheet.launch(context: context);

    if (newName != null) {
      _categoryCubit.createCategory(name: newName);
    }
  }

  void _onUpdateCategory(Category update) async {
    final updatedName = await CategoryNameFormSheet.launch(
      context: context,
      initial: update.name,
    );
    // if (updatedName != null) {
    //   final updatedCategory = update.copyWith(name: updatedName);
    //   _categoryCubit.updateCategory(updatedCategory);
    // }
  }

  void _onDeleteCategory(Category target) async {
    _categoryCubit.deleteCategory(target);
  }

  void _onQtyCategoryChanged(Category updated) {
    _categoryCubit.updateCategory(updated);
  }

  void _onCheckout() async {
    final checkoutData = await CheckoutDialog(
      categories: _categoryCubit.state.categories,
    ).show(context);

    if (checkoutData != null) {
      checkoutData.note;
      checkoutData.amount;
      // hit api buat checkout
      // _categoryCubit.charge(ammount, checkoutData.note);
      log(
        {"ammount": checkoutData.amount, "note": checkoutData.note}.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = context.mediaQuery.padding.bottom;
    final bodyPadding = EdgeInsets.only(
      top: 12,
      left: 12,
      right: 12,
      bottom: bottom + 16,
    );

    return KeyboardDismisser(
      dismissOnDrag: true,
      onTapOutside: context.hideSnackbar,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CategoryAppBar(onAddCategory: _onAddCategory),
        drawer: Drawer(child: SafeArea(child: CustomDrawer())),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, s) {
            if (s.status == CategoryStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (s.status == CategoryStatus.failure) {
              return Center(child: Text(s.message ?? "Terjadi kesalahan"));
            }

            if (s.categories.isEmpty) return _buildEmpty();

            return RefreshIndicator(
              onRefresh: () async {
                await _categoryCubit.fetchCategories();
              },
              child: ListView.separated(
                padding: bodyPadding,
                itemCount: s.categories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final category = s.categories[index];
                  return CategoryListTile(
                    category: category,
                    onUpdate: () {
                      //
                    },
                    onDelete: () {
                      //
                    },

                    // onUpdate: () => _onUpdateCategory(category),
                    // onDelete: () => _onDeleteCategory(category),
                    onQtyChanged: (q) {
                      // _onQtyCategoryChanged(category.copyWith(qty: q));
                    },
                  );
                },
              ),
            );
          },
        ),
        bottomSheet: BlocSelector<CategoryCubit, CategoryState, bool>(
          selector: (s) => s.categories.isNotEmpty,
          builder: (context, hasCategory) {
            return GestureDetector(
              onTap: () {
                if (hasCategory) return;
                ShowSnackbar.snackbar(
                  context,
                  "Tambahkan kategori terlebih dahulu",
                  isSuccess: false,
                );
              },
              child: CategoryActionBottomSheet(
                onCheckout: hasCategory ? _onCheckout : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    final hintColor = Colors.grey.shade400;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
    );
  }
}
