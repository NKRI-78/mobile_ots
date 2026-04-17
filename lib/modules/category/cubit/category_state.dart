part of 'category_cubit.dart';

enum CategoryStatus { initial, loading, success, failure, created }

class CategoryState extends Equatable {
  final List<Category> categories;
  final CategoryStatus fetchStatus;
  final CategoryStatus createStatus;
  final CategoryStatus updateStatus;
  final CategoryStatus deleteStatus;
  final bool isResettingQty;
  final bool isResetQtyCompleted;
  final AppError? error;

  const CategoryState({
    this.categories = const <Category>[],
    this.fetchStatus = CategoryStatus.initial,
    this.createStatus = CategoryStatus.initial,
    this.updateStatus = CategoryStatus.initial,
    this.deleteStatus = CategoryStatus.initial,
    this.isResettingQty = false,
    this.isResetQtyCompleted = false,
    this.error,
  });

  @override
  List<Object?> get props => [
    categories,
    fetchStatus,
    createStatus,
    updateStatus,
    deleteStatus,
    isResettingQty,
    isResetQtyCompleted,
    error,
  ];

  CategoryState copyWith({
    List<Category>? categories,
    CategoryStatus? fetchStatus,
    CategoryStatus? createStatus,
    CategoryStatus? updateStatus,
    CategoryStatus? deleteStatus,
    bool? isResettingQty,
    bool? isResetQtyCompleted,
    AppError? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      createStatus: createStatus ?? this.createStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      isResettingQty: isResettingQty ?? this.isResettingQty,
      isResetQtyCompleted: isResetQtyCompleted ?? this.isResetQtyCompleted,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((e) => e.toJson()).toList(),
      'fetch_status': fetchStatus.name,
      'create_status': createStatus.name,
      'update_status': updateStatus.name,
      'delete_status': deleteStatus.name,
      'is_resetting_qty': isResettingQty,
      'is_reset_qty_completed': isResetQtyCompleted,
      'error': error?.toJson(),
    };
  }

  factory CategoryState.fromJson(Map<String, dynamic> map) {
    return CategoryState(
      categories: (map['categories'] as List<dynamic>? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
      fetchStatus: CategoryStatus.values.firstWhere((e) {
        return e.name == map['fetch_status'];
      }, orElse: () => CategoryStatus.initial),
      createStatus: CategoryStatus.values.firstWhere((e) {
        return e.name == map['create_status'];
      }, orElse: () => CategoryStatus.initial),
      updateStatus: CategoryStatus.values.firstWhere((e) {
        return e.name == map['update_status'];
      }, orElse: () => CategoryStatus.initial),
      deleteStatus: CategoryStatus.values.firstWhere((e) {
        return e.name == map['delete_status'];
      }, orElse: () => CategoryStatus.initial),
      isResettingQty: map['is_resetting_qty'],
      isResetQtyCompleted: map['is_reset_qty_completed'],
      error: map['error'] != null ? AppError.fromJson(map['error']) : null,
    );
  }
}
