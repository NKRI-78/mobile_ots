import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/misc/injections.dart';
import 'package:mobile_ots/modules/category/cubit/category_cubit.dart';
import 'package:mobile_ots/modules/category/widget/category_app_bar.dart';
import 'package:mobile_ots/modules/category/widget/category_bottom_sheet.dart';
import 'package:mobile_ots/modules/category/widget/category_list_tile.dart';
import 'package:mobile_ots/modules/category/widget/category_name_form_sheet.dart';
import 'package:mobile_ots/repositories/category/model/category.dart';
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
  }

  void _onAddCategory() async {
    final newName = await CategoryNameFormSheet.launch(context: context);
    if (newName != null) {
      final newCategory = Category(id: Uuid().v4(), name: newName);
      _categoryCubit.addCategory(newCategory);
    }
  }

  void _onUpdate(Category update) async {
    final updatedName = await CategoryNameFormSheet.launch(
      context: context,
      initial: update.name,
    );
    if (updatedName != null) {
      final updatedCategory = update.copyWith(name: updatedName);
      _categoryCubit.updateCategory(updatedCategory);
    }
  }

  void _onDelete(Category target) async {
    _categoryCubit.deleteCategory(target);
  }

  void _onQtyCategoryChanged(Category updated) {
    _categoryCubit.updateCategory(updated);
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CategoryAppBar(onAddCategory: _onAddCategory),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, s) {
            if (s.categories.isEmpty) return _buildEmpty();
            return RefreshIndicator(
              onRefresh: () async {},
              child: ListView.separated(
                padding: bodyPadding,
                itemCount: s.categories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final category = s.categories[index];
                  return CategoryListTile(
                    category: category,
                    onUpdate: () => _onUpdate(category),
                    onDelete: () => _onDelete(category),
                    onQtyChanged: (q) {
                      _onQtyCategoryChanged(category.copyWith(qty: q));
                    },
                  );
                },
              ),
            );
          },
        ),
        bottomSheet: CategoryActionBottomSheet(onCheckout: () {}),
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
