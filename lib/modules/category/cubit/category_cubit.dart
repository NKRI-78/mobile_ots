import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mobile_ots/repositories/category/model/category.dart';

part 'category_state.dart';

class CategoryCubit extends HydratedCubit<CategoryState> {
  CategoryCubit() : super(CategoryState());

  void addCategory(Category newCategory) {
    emit(state.copyWith(categories: [...state.categories, newCategory]));
  }

  void updateCategory(Category update) {
    final index = state.categories.indexWhere((c) => c.id == update.id);
    if (index == -1) return;

    final newCategories = List<Category>.from(state.categories);
    newCategories[index] = update;

    emit(state.copyWith(categories: newCategories));
  }

  void deleteCategory(Category target) {
    final newCategories = state.categories
        .where((c) => c.id != target.id)
        .toList();

    emit(state.copyWith(categories: newCategories));
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) {
    try {
      return CategoryState.fromJson(json);
    } catch (_) {
      return const CategoryState();
    }
  }

  @override
  Map<String, dynamic>? toJson(CategoryState state) {
    return state.toJson();
  }
}
