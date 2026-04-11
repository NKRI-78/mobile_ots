import 'package:flutter/material.dart';
import 'package:mobile_ots/widgets/button/primary_button.dart';

class CategoryActionBottomSheet extends StatelessWidget {
  const CategoryActionBottomSheet({super.key, required this.onCheckout});

  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final padding = EdgeInsets.only(
      top: 4,
      left: 16,
      right: 16,
      bottom: bottom + 16,
    );

    return Container(
      width: double.infinity,
      padding: padding,
      color: Colors.grey.shade200,
      child: PrimaryButton(label: "Bayar", onPressed: onCheckout),
    );
  }
}
