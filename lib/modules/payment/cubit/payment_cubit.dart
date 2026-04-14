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
  Future<void> createPayment(PaymentRequstData req) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      final res = await repo.createPayment(req);
      emit(state.copyWith(response: res, status: PaymentStatus.success));
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          error: AppError(title: e.title, message: e.message),
          status: PaymentStatus.failure,
        ),
      );
    }
  }
}
