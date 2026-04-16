import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/misc/request_status.dart';
import 'package:mobile_ots/misc/socket.dart';
import 'package:mobile_ots/modules/transaction/cubit/transaction_cubit.dart';
import 'package:mobile_ots/repositories/transaction/model/transaction_models.dart';
import 'package:mobile_ots/router/builder.dart';
import 'package:mobile_ots/widgets/appbar/custom_app_bar.dart';
import 'package:mobile_ots/widgets/button/primary_button.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({
    super.key,
    required this.referenceId,
    required this.hasPaid,
  });

  final String? referenceId;
  final bool hasPaid;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late TransactionCubit _transactionCubit;

  @override
  void initState() {
    super.initState();
    _transactionCubit = context.read<TransactionCubit>();
    _resetTransactionFlagWhenUnpaid();
    _listenSocketWhenUnpaid();
    _fetchTransactionDetail();
  }

  @override
  void dispose() {
    super.dispose();
    _offSocket();
  }

  //// =========================================
  //// SOO SOOSOOOOO KETTTTT SOKET
  //// =========================================

  //* listen socket
  _listenSocketWhenUnpaid() {
    if (widget.hasPaid) return;
    SocketService().on("payment-update", (data) {
      // contoh response socket
      // {order_id: e3307a5d-4306-46f7-aeba-b38a875852fa, status: 2, user_id: 1},
      log('[TransactionDetailPage].listenSocket payment-update: $data');
      final status = data['status'];
      final success =
          (status is int && status == 2) || (status is String && status == '2');

      // kalau transaksi berhasil sebenernya cuma mark state aja
      if (mounted && success) {
        // pertama mark dulu statusnya jadi true biar state langsung berubah
        // kedua baru mark transaction sekarang .status == paid dalam list transaksi
        // ketika back kehalaman daftar transaksi
        _transactionCubit.markTransactionStatusFlag(paid: true);
        if (widget.referenceId != null) {
          _transactionCubit.markTransactionStatusByRefId(
            widget.referenceId!,
            paid: true,
          );
        }
      }
    });
  }

  //* off socket
  void _offSocket() {
    if (widget.hasPaid) return;
    SocketService().off("payment-update");
  }

  //// =========================================
  //// INTERNAL BISNIS LOJIK
  //// =========================================

  //* fetch transaction detail
  Future<void> _fetchTransactionDetail() async {
    if (widget.referenceId != null) {
      _transactionCubit.getTransactionByRefId(widget.referenceId!);
    }
  }

  //* format rupiah
  String _formatRupiah(int? value, {bool withSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: withSymbol ? 'Rp ' : '',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  //* mark transaction status flag
  void _resetTransactionFlagWhenUnpaid() {
    if (widget.hasPaid) return;
    _transactionCubit.markTransactionStatusFlag(paid: false);
  }

  //* format date
  String _formatDateFromString(String? isoString) {
    if (isoString == null) return "-";
    try {
      final date = DateTime.parse(isoString).toLocal();
      final formatter = DateFormat('EEEE, d MMM yyyy', 'id_ID');
      return formatter.format(date);
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final referenceId = widget.referenceId;

    final bottom = context.mediaQuery.padding.bottom;
    final bodyPadding = EdgeInsets.only(
      top: 16,
      left: 16,
      right: 16,
      bottom: bottom + 150,
    );
    final bottomPadding = EdgeInsets.only(
      top: 4,
      left: 16,
      right: 16,
      bottom: bottom + 16,
    );

    return Scaffold(
      appBar: CustomAppBar(titleText: "Qr Pembayaran"),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, s) {
          if (referenceId == null || referenceId.isEmpty) {
            return _buildInvalidTransaction();
          }

          final showLoading =
              s.transactionDetailStatus == RequestStatus.loading;
          final showError =
              s.transactionDetailStatus == RequestStatus.error &&
              s.error != null;

          if (showLoading) return _buildLoading();
          if (showError) return _buildError(s.error!);

          final transactionData = s.transactionData;
          final categories = transactionData?.categories ?? [];
          final hasNote =
              transactionData?.note != null &&
              (transactionData?.note?.isNotEmpty ?? false);

          return RefreshIndicator(
            onRefresh: _fetchTransactionDetail,
            child: ListView(
              padding: bodyPadding,
              children: [
                // logo e-tupay
                Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 60,
                    height: 40,
                  ),
                ),
                const SizedBox(height: 24),

                // qr
                _buildQrOrTransactionStatus(s),
                const SizedBox(height: 24),

                // total pembayaran
                Text(
                  _formatRupiah(transactionData?.amount),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                // current date
                Text(
                  _formatDateFromString(transactionData?.createdAt),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 24),

                // catatan
                if (hasNote) _buildNote(transactionData!.note!),

                // list transaksi
                _buildTransactionList(categories),
              ],
            ),
          );
        },
      ),
      bottomSheet: BlocSelector<TransactionCubit, TransactionState, bool>(
        selector: (s) {
          final hasPaidByTransactionStatus = s.transactionData?.status == "2";
          return s.hasPaidBySocketFlag || hasPaidByTransactionStatus;
        },
        builder: (context, hasPaidByState) {
          final hasPaidByParam = widget.hasPaid;
          final showButton = hasPaidByParam || hasPaidByState;
          if (!showButton) return const SizedBox.shrink();
          return Container(
            width: double.infinity,
            padding: bottomPadding,
            color: Colors.white,
            child: PrimaryButton(
              label: "Kembali",
              onPressed: () => CategoryRoutes().go(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvalidTransaction() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),

            const Text(
              "Transaksi Tidak Valid",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              "Referensi transaksi tidak ditemukan atau sudah tidak berlaku.",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(label: "Kembali", onPressed: context.pop),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(color: context.theme.primaryColor),
    );
  }

  Widget _buildError(AppError error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),

            Text(
              error.title?.isNotEmpty == true
                  ? error.title!
                  : "Terjadi Kesalahan",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              error.message,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                TextButton(
                  onPressed: context.pop,
                  child: const Text("Kembali"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: "Coba Lagi",
                    onPressed: _fetchTransactionDetail,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrOrTransactionStatus(TransactionState s) {
    const size = 220.0;

    final qrUrl = s.transactionData?.provider?.data?.qr?.qrUrl;

    if (qrUrl == null || qrUrl.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            widget.hasPaid ? "Pembayaran berhasil" : "QR belum tersedia",
          ),
        ),
      );
    }

    final paymentSuccessWidget = SizedBox(
      width: size,
      height: size,
      child: const Center(child: Text("Pembayaran berhasil")),
    );

    final qrWidget = CachedNetworkImage(
      imageUrl: qrUrl,
      imageBuilder: (context, i) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            image: DecorationImage(image: i, fit: BoxFit.contain),
          ),
        );
      },
      placeholder: (context, url) {
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: CircularProgressIndicator(color: context.theme.primaryColor),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return SizedBox(
          width: size,
          height: size,
          child: const Center(
            child: Text(
              "Kode QR tidak dapat dimuat",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );

    // ini handle dilevel socket
    // refresh ke success state kalau sudah status berubah via socket
    if (!widget.hasPaid && s.hasPaidBySocketFlag) {
      return paymentSuccessWidget;
    }

    // ini handle ketika user refresh halaman
    // kalo via scoket ga keupdate2 maka handlenya disini
    if (s.transactionData?.status == "2") {
      return paymentSuccessWidget;
    }

    // ini langsung hardcode ke success karena datanya valid via parameter
    if (widget.hasPaid) return paymentSuccessWidget;

    return qrWidget;
  }

  Widget _buildNote(String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Catatan", style: TextStyle(fontWeight: FontWeight.w500)),
          Text(note, style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionDataCategory> categories) {
    if (categories.isEmpty) {
      return const Center(child: Text("Tidak ada data pembayaran"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rincian Pembayaran",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),

        // Table
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: IntrinsicColumnWidth(),
            },
            children: [
              // Header
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 52, 52, 52),
                ),
                children: [
                  _headerCell("Kategori", align: TextAlign.left),
                  _headerCell("Qty", align: TextAlign.right),
                ],
              ),

              // Data rows
              ...categories.map(
                (c) => TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withValues(alpha: 0.06),
                        width: 0.5,
                      ),
                    ),
                  ),
                  children: [_dataCell(c.name), _qtyCell("${c.qty}")],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFFD3D1C7),
        ),
      ),
    );
  }

  Widget _dataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _qtyCell(String qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
          child: Text(
            qty,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
