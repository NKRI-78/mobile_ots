part of 'transaction_cubit.dart';

class TransactionState extends Equatable {
  final RequestStatus transactionDetailStatus;
  final RequestStatus transactionsStatus;
  final TransactionData? transactionData;
  final List<TransactionData> transactions;
  final bool hasPaidBySocketFlag;
  final int totalAmount;
  final SortMode sortMode;
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
    this.totalAmount = 0,
    this.sortMode = SortMode.newest,
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
    totalAmount,
    error,
    transactions,
    currentPage,
    sortMode,
    hasMore,
    isFetchingMore,
  ];

  TransactionState copyWith({
    RequestStatus? transactionDetailStatus,
    RequestStatus? transactionsStatus,
    TransactionData? transactionData,
    AppError? error,
    SortMode? sortMode,
    bool? hasPaidBySocketFlag,
    List<TransactionData>? transactions,
    int? currentPage,
    int? totalAmount,
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
      sortMode: sortMode ?? this.sortMode,
      totalAmount: totalAmount ?? this.totalAmount,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
