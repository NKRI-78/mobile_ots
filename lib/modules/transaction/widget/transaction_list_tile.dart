import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ots/repositories/transaction/model/transaction_models.dart';
import 'package:mobile_ots/router/builder.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile(this.transaction, {super.key});

  final TransactionData transaction;

  bool get hasPaid => transaction.status == "2";

  void _navigateToDetail(BuildContext context) {
    TransactionDetailRoutes(
      referenceId: transaction.referenceId,
      hasPaid: hasPaid,
    ).push(context);
  }

  String _formatTransactionDate(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat('EEEE, d MMM yyyy • HH.mm', 'id_ID').format(date);
    } catch (_) {
      return "-";
    }
  }

  String _formatRupiah(int? value, {bool withSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: withSymbol ? 'Rp ' : '',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: hasPaid
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.orange.withValues(alpha: 0.15),
        foregroundColor: hasPaid ? Colors.green : Colors.orange,
        child: Icon(hasPaid ? Icons.check_circle : Icons.schedule),
      ),
      title: Text(_formatTransactionDate(transaction.createdAt ?? "")),
      subtitle: Text(_formatRupiah(transaction.amount)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _navigateToDetail(context),
      titleTextStyle: TextStyle(fontSize: 14.5, color: Colors.black),
      subtitleTextStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
    );
  }
}
