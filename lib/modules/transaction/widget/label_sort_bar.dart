import 'package:flutter/material.dart';
import 'package:mobile_ots/misc/extensions.dart';

class LabelSortBar extends StatelessWidget {
  const LabelSortBar({
    super.key,
    required this.height,
    required this.onSortingPressed,
  });

  final double height;
  final VoidCallback onSortingPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Semua Transaksi",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            GestureDetector(
              onTap: onSortingPressed,
              child: Icon(Icons.sort, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
