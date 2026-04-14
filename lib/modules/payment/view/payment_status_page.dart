import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_ots/modules/payment/cubit/payment_cubit.dart';
import 'package:mobile_ots/widgets/appbar/custom_app_bar.dart';

class PaymentStatusPage extends StatefulWidget {
  const PaymentStatusPage({super.key});

  @override
  State<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  // late PaymentCubit _paymentCubit;

  @override
  void initState() {
    super.initState();
    // _paymentCubit = context.read<PaymentCubit>();
    // _createPayment();
  }

  //* create payment
  // void _createPayment() {
  //   _paymentCubit.createPayment(widget.requstData);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Qr Pembayaran"),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, s) {
          final loading = s.status == PaymentStatus.loading;
          final error = s.status == PaymentStatus.failure && s.error != null;
          if (loading) return _buildLoading();
          if (error) return _buildError();
          return Container();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox();
  }

  Widget _buildError() {
    return SizedBox();
  }
}
