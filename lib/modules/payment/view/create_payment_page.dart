import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/extensions.dart';
import 'package:mobile_ots/modules/category/cubit/category_cubit.dart';
import 'package:mobile_ots/modules/payment/cubit/payment_cubit.dart';
import 'package:mobile_ots/repositories/payment/model/payment_models.dart';
import 'package:mobile_ots/router/builder.dart';
import 'package:mobile_ots/widgets/appbar/custom_app_bar.dart';
import 'package:mobile_ots/widgets/button/primary_button.dart';

class CreatePaymentPage extends StatefulWidget {
  const CreatePaymentPage({super.key, required this.requestData});

  final PaymentRequestData requestData;

  @override
  State<CreatePaymentPage> createState() => _CreatePaymentPageState();
}

class _CreatePaymentPageState extends State<CreatePaymentPage> {
  late PaymentCubit _paymentCubit;
  late CategoryCubit _categoryCubit;

  @override
  void initState() {
    super.initState();
    _paymentCubit = context.read<PaymentCubit>();
    _categoryCubit = context.read<CategoryCubit>();
    _createPayment();
  }

  //* create payment
  void _createPayment() {
    _paymentCubit.createPayment(widget.requestData);
  }

  //* state listener
  void _stateListener(BuildContext context, PaymentState s) {
    // kalo pembayaran berhasil app akan melakukan
    // 1. reset qty dimasing-masing kategori
    // 2. navigasi kehalaman transaction detail
    if (s.status == PaymentStatus.success) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (context.mounted) {
          // 1. reset qty dimasing-masing kategori
          _categoryCubit.resetQty();
          // 2. navigasi kehalaman transaction detail
          TransactionDetailRoutes(
            referenceId: s.referenceId,
            hasPaid: false,
          ).go(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: _stateListener,
      builder: (context, s) {
        final errorPayment = s.status == PaymentStatus.failure;
        return PopScope(
          canPop: errorPayment,
          child: Scaffold(
            appBar: CustomAppBar(automaticallyImplyLeading: errorPayment),
            body: Builder(
              builder: (context) {
                final Widget child;
                if (s.status == PaymentStatus.success) {
                  child = _buildRedirecting();
                } else if (s.status == PaymentStatus.failure &&
                    s.error != null) {
                  child = _buildError(s.error!);
                } else {
                  child = _buildLoading();
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(key: ValueKey(s.status), child: child),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.theme.primaryColor),
          const SizedBox(height: 16),
          const Text(
            "Sedang memproses pembayaran...",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "Mohon tunggu dan jangan tutup halaman ini",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRedirecting() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.theme.primaryColor),
          const SizedBox(height: 16),
          const Text(
            "Membuka detail pembayaran...",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildError(AppError error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              error.title ?? "Pembayaran Gagal",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: "Coba Lagi", onPressed: _createPayment),
          ],
        ),
      ),
    );
  }
}
