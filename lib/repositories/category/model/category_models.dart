class Category {
  final int id;
  final String name;
  final int sortNo;
  final int isActive;
  final int qty;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.sortNo,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.qty = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      qty: json['qty'] ?? 0,
      sortNo: json['sort_no'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'sort_no': sortNo,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
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

  CreateCategoryResponse({required this.id});

  factory CreateCategoryResponse.fromJson(Map<String, dynamic> json) {
    return CreateCategoryResponse(id: json['data']['id']);
  }
}

class ChargeRequest {
  final int amount;
  final String referenceId;
  final int expiredIn;
  final List<ChargeItem> items;
  final List<ChargeCategory> categories;
  final ChargeCustomer customer;
  final String? note;

  ChargeRequest({
    required this.amount,
    required this.referenceId,
    required this.expiredIn,
    required this.items,
    required this.categories,
    required this.customer,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'reference_id': referenceId,
      'expired_in': expiredIn,
      'items': items.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'customer': customer.toJson(),
      if (note != null) 'note': note,
    };
  }
}

class ChargeItem {
  final String product;
  final int amount;
  final int qty;

  ChargeItem({required this.product, required this.amount, required this.qty});

  Map<String, dynamic> toJson() {
    return {'product': product, 'amount': amount, 'qty': qty};
  }
}

class ChargeCategory {
  final int categoryId;
  final String categoryName;
  final int sortNo;
  final int qty;
  final int amount;

  ChargeCategory({
    required this.categoryId,
    required this.categoryName,
    required this.sortNo,
    required this.qty,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'sort_no': sortNo,
      'qty': qty,
      'amount': amount,
    };
  }
}

class ChargeCustomer {
  final String name;
  final String email;
  final String phone;

  ChargeCustomer({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone};
  }
}
