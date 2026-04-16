class PaymentRequestData {
  final int amount;
  final List<PaymentRequestDataItem> items;
  final String? note;
  final PaymentRequestDataCustomer customer;
  final int expiredIn;

  PaymentRequestData({
    required this.amount,
    required this.items,
    required this.note,
    required this.customer,
    this.expiredIn = 30,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'note': note,
      'expired_in': expiredIn,
      'customer': customer.toJson(),
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

class PaymentRequestDataCustomer {
  final String name;
  final String email;
  final String phone;

  PaymentRequestDataCustomer({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'email': email, 'phone': phone};
  }
}

class PaymentRequestDataItem {
  final String product;
  final int qty;
  final int amount;

  PaymentRequestDataItem({
    required this.product,
    required this.qty,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'product': product, 'qty': qty, 'amount': amount};
  }
}
