part of 'payment_cubit.dart';

enum PaymentStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final PaymentResponse? response;
  final AppError? error;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.response,
    this.error,
  });

  @override
  List<Object?> get props => [status, response, error];

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentResponse? response,
    AppError? error,
  }) {
    return PaymentState(
      status: status ?? this.status,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }
}
