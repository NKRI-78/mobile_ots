part of 'transaction_cubit.dart';

class TransactionState extends Equatable {
  final RequestStatus transactionDetailStatus;
  final RequestStatus transactionsStatus;
  final TransactionData? transactionData;
  final List<TransactionData> transactions;
  final bool hasPaidBySocketFlag;
  final AppError? error;

  // pagination
  final int currentPage;
  final bool hasMore;
  final bool isFetchingMore;

  const TransactionState({
    this.transactionsStatus = RequestStatus.idle,
    this.transactionDetailStatus = RequestStatus.idle,
    this.transactionData,
    this.error,
    this.hasPaidBySocketFlag = false,
    this.transactions = const <TransactionData>[],
    this.currentPage = 1,
    this.hasMore = true,
    this.isFetchingMore = false,
  });

  @override
  List<Object?> get props => [
    transactionDetailStatus,
    transactionsStatus,
    transactionData,
    hasPaidBySocketFlag,
    error,
    transactions,
    currentPage,
    hasMore,
    isFetchingMore,
  ];

  TransactionState copyWith({
    RequestStatus? transactionDetailStatus,
    RequestStatus? transactionsStatus,
    TransactionData? transactionData,
    AppError? error,
    bool? hasPaidBySocketFlag,
    List<TransactionData>? transactions,
    int? currentPage,
    bool? hasMore,
    bool? isFetchingMore,
  }) {
    return TransactionState(
      transactionDetailStatus:
          transactionDetailStatus ?? this.transactionDetailStatus,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      transactionData: transactionData ?? this.transactionData,
      hasPaidBySocketFlag: hasPaidBySocketFlag ?? this.hasPaidBySocketFlag,
      error: error ?? this.error,
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
