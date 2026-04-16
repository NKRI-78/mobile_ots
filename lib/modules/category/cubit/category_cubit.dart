import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/injections.dart';
import 'package:mobile_ots/repositories/category/model/category_models.dart';

import '../../../repositories/category/repository/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends HydratedCubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  final CategoryRepository repo = getIt<CategoryRepository>();

  //* fetch category
  Future<void> fetchCategories() async {
    emit(
      state.copyWith(
        fetchStatus: CategoryStatus.loading,
        createStatus: CategoryStatus.initial,
        deleteStatus: CategoryStatus.initial,
        updateStatus: CategoryStatus.initial,
      ),
    );
    try {
      final result = await repo.fetchCategories();
      emit(
        state.copyWith(categories: result, fetchStatus: CategoryStatus.success),
      );
      log(
        "CategoryCubit.fetchCategories from remote = ${result.map((e) => e.toJson())} ",
        name: "CATEGORY_CUBIT: $hashCode",
      );
      log(
        "CategoryCubit.fetchCategories from state.categories after emit = ${state.categories.map((e) => e.toJson())} ",
        name: "CATEGORY_CUBIT: $hashCode",
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          fetchStatus: CategoryStatus.failure,
          error: AppError(title: e.title, message: e.message),
        ),
      );
    }
  }

  //* create category
  Future<void> createCategory(String name) async {
    final tempCategory = Category(id: 0, name: name);
    final prevCategories = state.categories;
    emit(
      state.copyWith(
        categories: [...prevCategories, tempCategory],
        createStatus: CategoryStatus.loading,
        fetchStatus: CategoryStatus.initial,
        deleteStatus: CategoryStatus.initial,
        updateStatus: CategoryStatus.initial,
      ),
    );

    try {
      final res = await repo.createCategory(tempCategory);
      log(
        "CategoryCubit.createCategory created from remote = ${{"id": res.id, "qty": res.qty}} ",
        name: "CATEGORY_CUBIT: $hashCode",
      );
      final updatedCategories = state.categories.map((c) {
        if (identical(c, tempCategory)) {
          return c.copyWith(id: res.id, qty: res.qty);
        }
        return c;
      }).toList();
      emit(
        state.copyWith(
          categories: updatedCategories,
          createStatus: CategoryStatus.created,
        ),
      );
      log(
        "CategoryCubit.createCategory update categories state after remote = ${state.categories.map((e) => e.toJson())} ",
        name: "CATEGORY_CUBIT: $hashCode",
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          categories: prevCategories,
          createStatus: CategoryStatus.failure,
          error: AppError(title: e.title, message: e.message),
        ),
      );
    }
  }

  //* update category
  Future<void> updateCategory(Category update) async {
    final prevCategories = state.categories;
    final index = prevCategories.indexWhere((c) => c.id == update.id);
    if (index == -1) return;
    final updatedCategories = List<Category>.from(prevCategories);
    updatedCategories[index] = update;
    emit(
      state.copyWith(
        categories: updatedCategories,
        updateStatus: CategoryStatus.loading,
        fetchStatus: CategoryStatus.initial,
        createStatus: CategoryStatus.initial,
        deleteStatus: CategoryStatus.initial,
      ),
    );

    log(
      "CategoryCubit.updateCategory optimistic categories before remote = ${state.categories.map((e) => e.toJson())} ",
      name: "CATEGORY_CUBIT: $hashCode",
    );

    try {
      final updatedCategory = await repo.updateCategory(update);
      log(
        "CategoryCubit.updateCategory updated category from remote = ${updatedCategory.toJson()} ",
        name: "CATEGORY_CUBIT: $hashCode",
      );
      final syncedCategories = state.categories.map((c) {
        if (c.id == updatedCategory.id) return updatedCategory;
        return c;
      }).toList();
      emit(
        state.copyWith(
          categories: syncedCategories,
          updateStatus: CategoryStatus.success,
        ),
      );
      log(
        "CategoryCubit.updateCategory categories after remote = ${state.categories.map((e) => e.toJson())} ",
        name: "CATEGORY_CUBIT: $hashCode",
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          error: AppError(title: e.title, message: e.message),
          categories: prevCategories,
          updateStatus: CategoryStatus.failure,
        ),
      );
    }
  }

  //* delete category
  Future<void> deleteCategory(Category target) async {
    final prevCategories = state.categories;
    final updateCategories = prevCategories
        .where((c) => c.id != target.id)
        .toList();
    emit(
      state.copyWith(
        categories: updateCategories,
        deleteStatus: CategoryStatus.loading,
        fetchStatus: CategoryStatus.initial,
        createStatus: CategoryStatus.initial,
        updateStatus: CategoryStatus.initial,
      ),
    );
    log(
      "CategoryCubit.deleteCategory optimistic categories before remote = ${state.categories.map((e) => e.toJson())} ",
      name: "CATEGORY_CUBIT: $hashCode",
    );
    try {
      await repo.deleteCategoryById(target.id);
      emit(state.copyWith(deleteStatus: CategoryStatus.success));
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          deleteStatus: CategoryStatus.failure,
          error: AppError(title: e.title, message: e.message),
          categories: prevCategories,
        ),
      );
    }
  }

  //* reset all qty from categories
  Future<void> resetQty() async {
    final prevCategories = state.categories;
    final resetCategories = prevCategories
        .map((c) => c.copyWith(qty: 0))
        .toList();
    emit(state.copyWith(categories: resetCategories));
    try {
      final futures = prevCategories
          .where((c) => c.qty > 0)
          .map((c) => repo.updateCategory(c.copyWith(qty: 0)))
          .toList();
      await Future.wait(futures);
      log(
        "CategoryCubit.resetQty updated qty for every categories after hit api = ${resetCategories.map((e) => e.toJson())}",
        name: "CATEGORY_CUBIT: $hashCode",
      );
    } catch (e, s) {
      emit(state.copyWith(categories: prevCategories));
      log(
        "CategoryCubit.resetQty rollback due to error: $e",
        stackTrace: s,
        name: "CATEGORY_CUBIT: $hashCode",
      );
    }
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) {
    try {
      return CategoryState.fromJson(json);
    } catch (c) {
      log("CategoryState? fromJson catch = $json | ${c.toString()}");
      throw Exception("gagal memuat CategoryState");
    }
  }

  @override
  Map<String, dynamic>? toJson(CategoryState state) {
    return state.toJson();
  }
}
