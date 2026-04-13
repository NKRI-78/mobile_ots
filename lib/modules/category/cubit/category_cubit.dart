import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mobile_ots/misc/injections.dart';
import 'package:mobile_ots/repositories/category/model/category_models.dart';

import '../../../repositories/category/repository/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends HydratedCubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  final CategoryRepository repo = getIt<CategoryRepository>();

  Future<void> fetchCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading));

    try {
      final result = await repo.fetchCategories();

      emit(state.copyWith(categories: result, status: CategoryStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: CategoryStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> createCategory({required String name, String? shortNo}) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    try {
      await repo.createCategories(name: name, shortNo: shortNo);

      final result = await repo.fetchCategories();

      emit(state.copyWith(categories: result, status: CategoryStatus.creating));
    } catch (e) {
      emit(
        state.copyWith(status: CategoryStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> charge(int ammount, String? note) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    try {
      final chargeCategories = state.categories.map((c) {
        return ChargeCategory(
          categoryId: c.id,
          categoryName: c.name,
          sortNo: c.sortNo,
          qty: c.qty,
          amount: 0,
        );
      }).toList();

      final totalAmount = chargeCategories.fold<int>(
        0,
        (sum, e) => sum + (e.amount * e.qty),
      );

      final request = ChargeRequest(
        amount: totalAmount,
        referenceId: "cdc5e333-9b54-4607-b1f3-a19917f88337",
        expiredIn: 30,
        items: [
          ChargeItem(
            product: "Pembayaran Kategori",
            amount: totalAmount,
            qty: 1,
          ),
        ],
        categories: chargeCategories,
        customer: ChargeCustomer(
          name: "Guest",
          email: "guest@mail.com",
          phone: "000000",
        ),
        note: "Pembayaran kategori",
      );

      await repo.charge(request);

      emit(state.copyWith(status: CategoryStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: CategoryStatus.failure, message: e.toString()),
      );
    }
  }

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
