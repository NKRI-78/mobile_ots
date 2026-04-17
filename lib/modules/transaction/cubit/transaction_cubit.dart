import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/injections.dart';
import 'package:mobile_ots/misc/logger.dart';
import 'package:mobile_ots/misc/request_status.dart';
import 'package:mobile_ots/modules/transaction/widget/sorting_dialog_sheet.dart';
import 'package:mobile_ots/repositories/transaction/model/transaction_models.dart';
import 'package:mobile_ots/repositories/transaction/transaction_repository.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionState());

  final TransactionRepository repo = getIt<TransactionRepository>();

  //* get transactions history
  Future<void> getTransactions({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String sort = "newest",
  }) async {
    emit(state.copyWith(transactionsStatus: RequestStatus.loading));
    try {
      final result = await repo.getTransactions(
        page: page,
        limit: limit,
        search: search,
        sort: sort,
        status: status,
      );
      logger("TransactionCubit.getTransaction result = ${result.toMap()}");
      emit(
        state.copyWith(
          transactions: result.items,
          transactionsStatus: RequestStatus.success,
          currentPage: page,
          totalAmount: result.totalPaidAmount,
          hasMore: result.page < result.totalPages,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          error: AppError(title: e.title, message: e.message),
          transactionsStatus: RequestStatus.error,
        ),
      );
    }
  }

  //* load more pagination
  Future<void> loadMoreTransactions({String sort = "newest"}) async {
    if (!state.hasMore || state.isFetchingMore) return;

    emit(state.copyWith(isFetchingMore: true));
    try {
      final nextPage = state.currentPage + 1;
      final result = await repo.getTransactions(page: nextPage, sort: sort);
      emit(
        state.copyWith(
          transactions: [...state.transactions, ...result.items],
          isFetchingMore: false,
          currentPage: nextPage,
          hasMore: nextPage < result.totalPages,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          isFetchingMore: false,
          error: AppError(title: e.title, message: e.message),
        ),
      );
    }
  }

  //* get transaction by ref id
  Future<void> getTransactionByRefId(String refId) async {
    emit(state.copyWith(transactionDetailStatus: RequestStatus.loading));
    try {
      final newRemoteTransaction = await repo.getTransactionByRefId(refId);
      logger(
        "TransactionCubit.getTransactionByRefID newRemoteTransaction = ${newRemoteTransaction.toJson()}",
      );
      emit(
        state.copyWith(
          transactionData: newRemoteTransaction,
          transactionDetailStatus: RequestStatus.success,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          error: AppError(title: e.title, message: e.message),
          transactionDetailStatus: RequestStatus.error,
        ),
      );
    }
  }

  // =========================
  // DUA FUNGSI DIBAWAH DIBACA WOYY!!
  // JANGAN APA-APA PAKE AI, APA-APA PAKE AI
  // INI TULISAN ANTON BUKAN AI
  // YANG BUAT ANTON BUKAN AI!!!
  // AI AI MATAMUUU
  // =========================

  //* mark has paid when payment success
  // dipake cuma flagging state doang untuk mententukan apakah pembayaran berhasil atau gagal
  // ini tuh sama aja kaya isSuccess == true kalo pake setState(() {})
  void markTransactionStatusFlag({required bool paid}) {
    emit(state.copyWith(hasPaidBySocketFlag: paid));
  }

  //* mark transaction status by ref id
  // ya intinya sama aja buat flagging state doang
  // bedanya, fungsi ini digunakan setelah fungsi yang atas (markTransactionStatusFlag)
  // jadi pas lagi dihalaman status pembayaran && berhasil
  // ketika back kehalaman list transactions
  // ekspetasinya transaction yang sekarang statusnya akan berubah menjadi paid
  // diantara transaction-transaction yang lain
  // nah fungsi ini digunakan untuk itu
  void markTransactionStatusByRefId(String refId, {required bool paid}) {
    final updatedTransactions = state.transactions.map((e) {
      if (e.referenceId == refId) {
        return e.copyWith(status: paid ? "2" : "1");
      }
      return e;
    }).toList();
    emit(state.copyWith(transactions: updatedTransactions));
  }

  //* mark sort mode
  void markSortMode(SortMode newMode) {
    emit(state.copyWith(sortMode: newMode));
  }
}
