import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../contracts/presentation/bloc/contracts_bloc.dart';
import '../../domain/usecases/get_saved_contracts_usecase.dart';
import 'saved_event.dart';
import 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final GetSavedContractsUseCase getSavedContractsUseCase;
  final ContractsBloc contractsBloc;
  late StreamSubscription _contractsBlocSubscription;

  SavedBloc({
    required this.getSavedContractsUseCase,
    required this.contractsBloc,
  }) : super(const SavedState()) {
    on<FetchSavedContractsRequested>(_onFetchSavedContractsRequested);
    on<DeleteSavedContractRequested>(_onDeleteSavedContractRequested);
    on<RemoveSavedContractRequested>(_onRemoveSavedContractRequested);

    // Listen to ContractsBloc changes to update saved contracts
    _listenToContractsBloc();
  }

  void _listenToContractsBloc() {
    _contractsBlocSubscription = contractsBloc.stream.listen(
      (contractsState) {
        // Update saved contracts whenever ContractsBloc state changes
        if (contractsState.savedContracts.isNotEmpty) {
          // UseCase handles sorting (newest first)
          final sortedSaved = getSavedContractsUseCase.getSavedContractsFromList(
            contractsState.savedContracts,
          );

          emit(state.copyWith(
            status: SavedStatus.success,
            savedContracts: sortedSaved,
          ));
        } else {
          emit(state.copyWith(
            status: SavedStatus.success,
            savedContracts: [],
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(
          status: SavedStatus.failure,
          errorMessage: 'Error syncing saved contracts: $error',
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _contractsBlocSubscription.cancel();
    return super.close();
  }

  Future<void> _onFetchSavedContractsRequested(
    FetchSavedContractsRequested event,
    Emitter<SavedState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SavedStatus.loading, savedContracts: []));

      // Get saved contracts from ContractsBloc state
      final savedContracts = contractsBloc.state.savedContracts;

      if (savedContracts.isEmpty) {
        emit(state.copyWith(
          status: SavedStatus.success,
          savedContracts: [],
        ));
        return;
      }

      // UseCase handles sorting (newest first)
      final sortedSaved = getSavedContractsUseCase.getSavedContractsFromList(savedContracts);

      emit(state.copyWith(
        status: SavedStatus.success,
        savedContracts: sortedSaved,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SavedStatus.failure,
        errorMessage: 'Failed to fetch saved contracts: $e',
      ));
    }
  }

  Future<void> _onDeleteSavedContractRequested(
    DeleteSavedContractRequested event,
    Emitter<SavedState> emit,
  ) async {
    try {
      final updatedSaved = state.savedContracts.where((c) => c.id != event.id).toList();
      emit(state.copyWith(
        status: SavedStatus.success,
        savedContracts: updatedSaved,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SavedStatus.failure,
        errorMessage: 'Failed to delete contract: $e',
      ));
    }
  }

  void _onRemoveSavedContractRequested(
    RemoveSavedContractRequested event,
    Emitter<SavedState> emit,
  ) {
    try {
      final updatedSaved = state.savedContracts.where((c) => c.id != event.id).toList();
      emit(state.copyWith(
        status: SavedStatus.success,
        savedContracts: updatedSaved,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SavedStatus.failure,
        errorMessage: 'Failed to remove saved contract: $e',
      ));
    }
  }
}
