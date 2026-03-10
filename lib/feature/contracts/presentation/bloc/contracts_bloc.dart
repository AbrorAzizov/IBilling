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
    on<DeleteContractRequested>(_onDeleteContractRequested);
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

    final result = await getContractsUseCase.repository.filterContracts(
      query: event.query,
      fromDate: event.fromDate,
      toDate: event.toDate,
      statuses: event.statuses,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: failure.message,
      )),
      (contracts) => emit(state.copyWith(
        status: ContractsStatus.success,
        contracts: contracts,
        hasReachedMax: true,
      )),
    );
  }

  Future<void> _onDeleteContractRequested(
    DeleteContractRequested event,
    Emitter<ContractsState> emit,
  ) async {
    final result = await getContractsUseCase.repository.deleteContract(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ContractsStatus.failure,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedContracts = state.contracts.where((c) => c.id != event.id).toList();
        emit(state.copyWith(
          status: ContractsStatus.success,
          contracts: updatedContracts,
        ));
      },
    );
  }
}
