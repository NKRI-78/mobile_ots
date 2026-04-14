// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:mobile_ots/misc/exception.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final int qty;
  final int? sortNo;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.sortNo,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.qty = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    try {
      return Category(
        id: json['id'],
        name: json['name'],
        qty: json['qty'] ?? 1,
        sortNo: json['sort_no'],
        isActive: json['is_active'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
    } catch (_) {
      throw ParsingException();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'sort_no': sortNo,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props {
    return [id, name, qty, sortNo, isActive, createdAt, updatedAt];
  }

  Category copyWith({
    int? id,
    String? name,
    int? qty,
    int? sortNo,
    int? isActive,
    String? createdAt,
    String? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      sortNo: sortNo ?? this.sortNo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CategoryResponse {
  final List<Category> items;

  CategoryResponse({required this.items});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      items: (json['data']['items'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}

class CreateCategoryResponse {
  final int id;
  final int qty;

  CreateCategoryResponse({required this.id, this.qty = 1});

  factory CreateCategoryResponse.fromJson(Map<String, dynamic> json) {
    try {
      return CreateCategoryResponse(
        id: json['data']['id'],
        qty: json['data']['qty'],
      );
    } catch (_) {
      throw ParsingException();
    }
  }
}

class ChargeRequest {
  final int amount;
  final String referenceId;
  final int expiredIn;
  final String? note;

  ChargeRequest({
    required this.amount,
    required this.referenceId,
    required this.expiredIn,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'reference_id': referenceId,
      'expired_in': expiredIn,
      if (note != null) 'note': note,
    };
  }
}
