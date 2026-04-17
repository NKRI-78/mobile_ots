import 'package:flutter/material.dart';
import 'package:mobile_ots/widgets/appbar/custom_app_bar.dart';

class CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoryAppBar({super.key, required this.onAddCategory});

  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      titleText: "Pilih Kategori",
      backgroundColor: Colors.white,
      actions: [IconButton(onPressed: onAddCategory, icon: Icon(Icons.add))],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
