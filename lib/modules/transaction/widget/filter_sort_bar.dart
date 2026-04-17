import 'package:flutter/material.dart';
import 'package:mobile_ots/misc/extensions.dart';

class SortModeBar extends StatelessWidget {
  const SortModeBar({
    super.key,
    required this.height,
    required this.onSortingPressed,
    required this.onFilterPressed,
  });

  final double height;
  final VoidCallback onSortingPressed;
  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: context.theme.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 16,
            children: [
              Expanded(
                child: _buildButton("Sort", Icons.sort, onSortingPressed),
              ),
              Expanded(
                child: _buildButton(
                  "Filter",
                  Icons.filter_list,
                  onFilterPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, IconData icons, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icons, size: 18), Text(label)],
          ),
        ),
      ),
    );
  }
}
