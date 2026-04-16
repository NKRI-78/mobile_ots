import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/injections.dart';
import 'package:mobile_ots/repositories/payment/model/payment_models.dart';
import 'package:mobile_ots/repositories/payment/repository/payment_repository.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentState());

  final PaymentRepository repo = getIt<PaymentRepository>();

  //* create payment
  Future<void> createPayment(PaymentRequestData req) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      final res = await repo.createPayment(req);
      emit(state.copyWith(referenceId: res, status: PaymentStatus.success));
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          error: AppError(title: e.title, message: e.message),
          status: PaymentStatus.failure,
        ),
      );
    }
  }

  //TODO: hapus kalau mau release
  Future<void> simulateCreatePayment(PaymentRequestData req) async {
    // * loading
    emit(state.copyWith(status: PaymentStatus.loading));
    await Future.delayed(const Duration(seconds: 2));

    // * success
    emit(state.copyWith(status: PaymentStatus.success, referenceId: ""));

    // * error
    // emit(
    //   state.copyWith(
    //     status: PaymentStatus.failure,
    //     error: const AppError(
    //       title: "Pembayaran Gagal",
    //       message: "Koneksi terputus, silakan coba lagi.",
    //     ),
    //   ),
    // );
  }
}
