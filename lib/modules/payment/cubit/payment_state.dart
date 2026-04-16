part of 'payment_cubit.dart';

enum PaymentStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final String? referenceId;
  final AppError? error;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.referenceId,
    this.error,
  });

  @override
  List<Object?> get props => [status, referenceId, error];

  PaymentState copyWith({
    PaymentStatus? status,
    String? referenceId,
    AppError? error,
  }) {
    return PaymentState(
      status: status ?? this.status,
      referenceId: referenceId ?? this.referenceId,
      error: error ?? this.error,
    );
  }
}
