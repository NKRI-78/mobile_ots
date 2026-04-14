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
  Future<void> createCategory(Category newCategory) async {
    final tempCategory = newCategory.copyWith(id: 0);
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

    try {
      final updatedCategory = await repo.updateCategory(update);
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
  void deleteCategory(Category target) async {
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

  // Future<void> charge(int ammount, String? note) async {
  //   emit(state.copyWith(status: CategoryStatus.loading));

  //   try {
  //     final chargeCategories = state.categories.map((c) {
  //       return ChargeCategory(
  //         categoryId: c.id,
  //         categoryName: c.name,
  //         sortNo: c.sortNo ?? 0,
  //         qty: c.qty,
  //         amount: 0,
  //       );
  //     }).toList();

  //     final totalAmount = chargeCategories.fold<int>(
  //       0,
  //       (sum, e) => sum + (e.amount * e.qty),
  //     );

  //     final request = ChargeRequest(
  //       amount: totalAmount,
  //       referenceId: "cdc5e333-9b54-4607-b1f3-a19917f88337",
  //       expiredIn: 30,
  //       items: [
  //         ChargeItem(
  //           product: "Pembayaran Kategori",
  //           amount: totalAmount,
  //           qty: 1,
  //         ),
  //       ],
  //       categories: chargeCategories,
  //       customer: ChargeCustomer(
  //         name: "Guest",
  //         email: "guest@mail.com",
  //         phone: "000000",
  //       ),
  //       note: "Pembayaran kategori",
  //     );

  //     await repo.charge(request);

  //     emit(state.copyWith(status: CategoryStatus.success));
  //   } catch (e) {
  //     emit(
  //       state.copyWith(status: CategoryStatus.failure, message: e.toString()),
  //     );
  //   }
  // }

  void addCategory(Category newCategory) {
    emit(state.copyWith(categories: [...state.categories, newCategory]));
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
