import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_ots/repositories/category/model/category_models.dart';
import 'package:mobile_ots/widgets/button/primary_button.dart';
import 'package:mobile_ots/widgets/utils/keyboard_dismisser.dart';

class CheckoutDialogResponseData {
  final int amount;
  final String note;
  final List<Category> categories;

  CheckoutDialogResponseData({
    required this.amount,
    required this.note,
    required this.categories,
  });
}

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({super.key, required this.categories});

  final List<Category> categories;

  Future<CheckoutDialogResponseData?> show(BuildContext context) {
    return showDialog<CheckoutDialogResponseData?>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _noteFocus = FocusNode();

  String? _amountError;
  String? _categoriesError;

  List<Category> get categories => widget.categories;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _noteFocus.dispose();
  }

  bool _validate(int amount) {
    if (amount <= 0) {
      setState(() => _amountError = "Jumlah tidak boleh kosong");
      return false;
    }
    if (widget.categories.isEmpty) {
      setState(() => _categoriesError = "Tidak ada kategori yang tersedia");
      return false;
    }
    if (!_formKey.currentState!.validate()) return false;
    return true;
  }

  void _onSubmit() {
    final rawAmount = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(rawAmount) ?? 0;
    if (_validate(amount)) {
      Navigator.of(context).pop(
        CheckoutDialogResponseData(
          amount: amount,
          note: _noteController.text,
          categories: widget.categories,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: KeyboardDismisser(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // pesanan
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Pesanan",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        "Qty",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                _buildCategoryList(),

                const SizedBox(height: 16),

                // jumlah uang
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    "Jumlah Uang",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextFormField(
                  controller: _amountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_RupiahInputFormatter()],
                  decoration: InputDecoration(
                    border: border,
                    hintText: "Masukan jumlah",
                    errorText: _amountError,
                  ),
                  onChanged: (v) {
                    if (_amountError != null && v.isNotEmpty) {
                      _amountError = null;
                      setState(() {});
                    }
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_noteFocus);
                  },
                ),

                const SizedBox(height: 16),

                // catatan
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    spacing: 6,
                    children: [
                      Text(
                        "Catatan",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "(Tidak Wajib)",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _noteController,
                  minLines: 4,
                  maxLines: 4,
                  focusNode: _noteFocus,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    border: border,
                    hintText: "Masukan catatan",
                  ),
                ),

                const SizedBox(height: 16),

                if (_categoriesError != null ||
                    (_categoriesError?.isNotEmpty ?? false))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _categoriesError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                // submit
                SizedBox(
                  width: double.maxFinite,
                  child: PrimaryButton(label: "Bayar", onPressed: _onSubmit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final constraints = const BoxConstraints(minHeight: 60, maxHeight: 120);

    if (categories.isEmpty) {
      return Container(
        constraints: constraints.copyWith(minHeight: 40),
        alignment: Alignment.center,
        child: Text(
          "Belum ada category",
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return Container(
      constraints: constraints,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final category = categories[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  category.qty.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RupiahInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final number = int.parse(digitsOnly);

    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
