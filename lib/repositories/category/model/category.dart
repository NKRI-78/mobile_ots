import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final int qty;

  const Category({required this.id, required this.name, this.qty = 0});

  Category copyWith({String? id, String? name, int? qty}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
    );
  }

  @override
  List<Object> get props => [id, name, qty];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'qty': qty};
  }

  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      qty: map['qty'] ?? 0,
    );
  }
}
