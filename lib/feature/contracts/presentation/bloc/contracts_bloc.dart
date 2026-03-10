import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_contracts_usecase.dart';
import 'contracts_event.dart';
import 'contracts_state.dart';

class ContractsBloc extends Bloc<ContractsEvent, ContractsState> {
  final GetContractsUseCase getContractsUseCase;

  ContractsBloc({
    required this.getContractsUseCase,
  }) : super(const ContractsState()) {
    on<FetchContractsRequested>(_onFetchContractsRequested);
    on<LoadMoreContractsRequested>(_onLoadMoreContractsRequested);
    on<FilterContractsRequested>(_onFilterContractsRequested);
  }

  Future<void> _onFetchContractsRequested(
    FetchContractsRequested event,
    Emitter<ContractsState> emit,
  ) async {
    emit(state.copyWith(status: ContractsStatus.loading, hasReachedMax: false, contracts: []));

    final result = await getContractsUseCase(limit: 3);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: failure.message,
      )),
      (contracts) => emit(state.copyWith(
        status: ContractsStatus.success,
        contracts: contracts,
        hasReachedMax: contracts.length < 3,
      )),
    );
  }

  Future<void> _onLoadMoreContractsRequested(
    LoadMoreContractsRequested event,
    Emitter<ContractsState> emit,
  ) async {
    if (state.hasReachedMax || state.status == ContractsStatus.loadingMore) return;

    emit(state.copyWith(status: ContractsStatus.loadingMore));

    final lastId = state.contracts.last.createdAt.toIso8601String();
    final result = await getContractsUseCase(limit: 3, lastId: lastId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: failure.message,
      )),
      (newContracts) => emit(state.copyWith(
        status: ContractsStatus.success,
        contracts: List.of(state.contracts)..addAll(newContracts),
        hasReachedMax: newContracts.length < 3,
      )),
    );
  }

  Future<void> _onFilterContractsRequested(
    FilterContractsRequested event,
    Emitter<ContractsState> emit,
  ) async {
    emit(state.copyWith(status: ContractsStatus.loading, contracts: []));

    // For now, using the repository's filter method if available or just fetching with constraints.
    // Since getContractsUseCase is what we have registered, let's see if we should use repository.
    // Actually, I'll use the repository directly or update the use case.
    // To keep it simple and consistent with what I wrote before, I'll assume the repo has filterContracts.
    
    final result = await getContractsUseCase.repository.filterContracts(
      query: event.query,
      fromDate: event.fromDate,
      toDate: event.toDate,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: failure.message,
      )),
      (contracts) => emit(state.copyWith(
        status: ContractsStatus.success,
        contracts: contracts,
        hasReachedMax: true, // Filters usually don't support pagination in this simple implementation
      )),
    );
  }
}
