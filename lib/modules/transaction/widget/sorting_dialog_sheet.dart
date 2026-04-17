import 'package:flutter/material.dart';
import 'package:mobile_ots/misc/extensions.dart';

enum SortMode { newest, oldest }

class SortingDialogSheet extends StatelessWidget {
  const SortingDialogSheet._();

  static Future<SortMode?> launch(BuildContext context) {
    return showModalBottomSheet<SortMode?>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(),
      builder: (context) {
        return SortingDialogSheet._();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = context.mediaQuery.padding.bottom;
    final padding = EdgeInsets.only(top: 12, bottom: bottom + 24);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SortOption(
              label: 'Terbaru',
              icon: Icons.arrow_downward_rounded,
              onTap: () => Navigator.of(context).pop(SortMode.newest),
            ),
            _SortOption(
              label: 'Terlama',
              icon: Icons.arrow_upward_rounded,
              onTap: () => Navigator.of(context).pop(SortMode.oldest),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF3A5FD9)),
      ),
    );
  }
}
