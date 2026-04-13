part of 'category_cubit.dart';

enum CategoryStatus { initial, loading, success, failure, creating, charging }

class CategoryState extends Equatable {
  final List<Category> categories;
  final CategoryStatus status;
  final String? message;

  const CategoryState({
    this.categories = const <Category>[],
    this.status = CategoryStatus.initial,
    this.message,
  });

  @override
  List<Object?> get props => [categories, status, message];

  CategoryState copyWith({
    List<Category>? categories,
    CategoryStatus? status,
    String? message,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {'categories': categories.map((e) => e.toJson()).toList()};
  }

  factory CategoryState.fromJson(Map<String, dynamic> map) {
    return CategoryState(
      categories: (map['categories'] as List<dynamic>? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}
