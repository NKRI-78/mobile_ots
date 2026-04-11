import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/repositories/category/model/category.dart';

class CategoryListTile extends StatefulWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    required this.onUpdate,
    required this.onDelete,
    required this.onQtyChanged,
  });

  final Category category;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final Function(int qty) onQtyChanged;

  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  late TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(
      text: widget.category.qty.toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _qtyController.dispose();
  }

  void _onDelete(BuildContext context) async {
    final shouldDelete = await _deleteConfirmationDialog();
    if (shouldDelete) widget.onDelete();
  }

  void _increment() {
    final current = int.tryParse(_qtyController.text) ?? 0;
    final newQty = current + 1;
    _qtyController.text = newQty.toString();
    widget.onQtyChanged(newQty);
  }

  void _decrement() {
    final current = int.tryParse(_qtyController.text) ?? 0;
    if (current <= 0) return;
    final newQty = current - 1;
    _qtyController.text = newQty.toString();
    widget.onQtyChanged(newQty);
  }

  @override
  Widget build(BuildContext context) {
    final radius = 6.0;
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => widget.onUpdate(),
            backgroundColor: context.theme.primaryColor,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Ubah',
          ),
          SlidableAction(
            onPressed: _onDelete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Hapus',
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(radius),
            ),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              flex: 3,
              child: _SectionContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.category.name,
                    maxLines: 5, 
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: _SectionContainer(
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _decrement,
                      child: Icon(Icons.remove),
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_QtyInputFormatter()],
                        onChanged: (v) {
                          final newQty = int.tryParse(v) ?? 0;
                          widget.onQtyChanged(newQty);
                        },
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(onTap: _increment, child: Icon(Icons.add)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _deleteConfirmationDialog() async {
    final buttonStyle = TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
    return await showDialog<bool?>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Konfirmasi Penghapusan Kategori"),
              content: Text.rich(
                TextSpan(
                  text: "Apakah Kamu yakin ingin menghapus ",
                  children: [
                    TextSpan(
                      text: widget.category.name,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: "?"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: buttonStyle.copyWith(
                    foregroundColor: WidgetStatePropertyAll(
                      Colors.grey.shade600,
                    ),
                    overlayColor: WidgetStatePropertyAll(Colors.grey.shade200),
                  ),
                  child: Text("Batal"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: buttonStyle,
                  child: Text("Hapus"),
                ),
              ],
              actionsPadding: EdgeInsets.only(bottom: 10, right: 10, top: 20),
              contentPadding: EdgeInsets.only(left: 24, top: 20, right: 24),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              titleTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ) ??
        false;
  }
}

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      constraints: BoxConstraints(minHeight: kMinInteractiveDimension),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade700),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

class _QtyInputFormatter extends TextInputFormatter {
  static const int max = 999;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return _format('0');
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return _format('0');
    int value = int.tryParse(digits) ?? 0;
    if (value < 0) value = 0;
    if (value > max) value = max;
    return _format(value.toString());
  }

  TextEditingValue _format(String value) {
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}
