import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/filter_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistoryUseCase;
  final FilterHistoryUseCase filterHistoryUseCase;

  HistoryBloc({
    required this.getHistoryUseCase,
    required this.filterHistoryUseCase,
  }) : super(const HistoryState()) {
    on<FetchHistoryRequested>(_onFetchHistoryRequested);
    on<FilterHistoryRequested>(_onFilterHistoryRequested);
    on<DeleteHistoryContractRequested>(_onDeleteHistoryContractRequested);
  }

  Future<void> _onFetchHistoryRequested(
    FetchHistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));

    final result = await getHistoryUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: failure.message,
      )),
      (contracts) => emit(state.copyWith(
        status: HistoryStatus.success,
        contracts: contracts,
      )),
    );
  }

  Future<void> _onFilterHistoryRequested(
    FilterHistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));

    final result = await filterHistoryUseCase(
      query: event.query,
      fromDate: event.fromDate,
      toDate: event.toDate,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: failure.message,
      )),
      (contracts) => emit(state.copyWith(
        status: HistoryStatus.success,
        contracts: contracts,
      )),
    );
  }

  Future<void> _onDeleteHistoryContractRequested(
    DeleteHistoryContractRequested event,
    Emitter<HistoryState> emit,
  ) async {
    final result = await getHistoryUseCase.repository.deleteContract(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedContracts = state.contracts.where((c) => c.id != event.id).toList();
        emit(state.copyWith(
          status: HistoryStatus.success,
          contracts: updatedContracts,
        ));
      },
    );
  }
}
