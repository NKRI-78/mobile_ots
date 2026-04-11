part of 'category_cubit.dart';

class CategoryState extends Equatable {
  final List<Category> categories;

  const CategoryState({this.categories = const <Category>[]});

  @override
  List<Object?> get props => [categories];

  CategoryState copyWith({List<Category>? categories}) {
    return CategoryState(categories: categories ?? this.categories);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'categories': categories.map((c) => c.toJson()).toList(),
    };
  }

  factory CategoryState.fromJson(Map<String, dynamic> map) {
    return CategoryState(
      categories: (map['categories'] as List<dynamic>? ?? [])
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
