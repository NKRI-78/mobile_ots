import 'package:flutter/material.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/widgets/button/primary_button.dart';

class CategoryNameFormSheet extends StatefulWidget {
  const CategoryNameFormSheet._(this.initial);

  final String? initial;

  static Future<String?> launch({
    required BuildContext context,
    String? initial,
  }) {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight: context.mediaQuery.size.height * 0.9,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return CategoryNameFormSheet._(initial);
      },
    );
  }

  @override
  State<CategoryNameFormSheet> createState() => _CategoryNameFormSheetState();
}

class _CategoryNameFormSheetState extends State<CategoryNameFormSheet> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _sanitizeText(String input) {
    return input
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .join('\n')
        .trim();
  }

  void _onSubmit() async {
    final result = _sanitizeText(_nameController.text);
    if (mounted && result.isNotEmpty) Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = context.mediaQuery.viewInsets.bottom;
    final padding = EdgeInsets.only(
      top: 14,
      left: 12,
      right: 12,
      bottom: bottom + 8,
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
    final titleText = widget.initial != null
        ? "Ubah Kategori"
        : "Tambah Kategori";
    final submitLabel = widget.initial != null ? "Perbaharui" : "Tambahkan";

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 4,
            children: [
              Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
              Text(
                titleText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          TextField(
            autofocus: true,
            controller: _nameController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 4,
            minLines: 1,
            decoration: InputDecoration(
              border: border,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(
                  color: context.theme.primaryColor,
                  width: 2.0,
                ),
              ),
              hintText: "Contoh: Festival atau VIP",
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
          ),

          const SizedBox(height: 12),

          PrimaryButton(label: submitLabel, onPressed: _onSubmit),
        ],
      ),
    );
  }
}
