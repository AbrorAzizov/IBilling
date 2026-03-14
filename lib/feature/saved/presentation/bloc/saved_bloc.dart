import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../contracts/presentation/bloc/contracts_bloc.dart';
import '../../domain/usecases/get_saved_contracts_usecase.dart';
import '../../domain/usecases/filter_saved_contracts_usecase.dart';
import 'saved_event.dart';
import 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final GetSavedContractsUseCase getSavedContractsUseCase;
  final FilterSavedContractsUseCase filterSavedContractsUseCase;
  final ContractsBloc contractsBloc;
  late StreamSubscription _contractsBlocSubscription;

  SavedBloc({
    required this.getSavedContractsUseCase,
    required this.filterSavedContractsUseCase,
    required this.contractsBloc,
  }) : super(const SavedState()) {
    on<FetchSavedContractsRequested>(_onFetchSavedContractsRequested);
    on<FilterSavedContractsRequested>(_onFilterSavedContractsRequested);

    _contractsBlocSubscription = contractsBloc.stream.listen((state) {
      add(const FetchSavedContractsRequested());
    });
  }

  Future<void> _onFetchSavedContractsRequested(
    FetchSavedContractsRequested event,
    Emitter<SavedState> emit,
  ) async {
    emit(state.copyWith(status: SavedStatus.loading));
    
    final savedFromContracts = contractsBloc.state.savedContracts;
    // Use the use case directly as a function (call method)
    final sortedSaved = getSavedContractsUseCase(savedFromContracts);
    
    emit(state.copyWith(
      status: SavedStatus.success,
      savedContracts: sortedSaved,
    ));
  }

  Future<void> _onFilterSavedContractsRequested(
    FilterSavedContractsRequested event,
    Emitter<SavedState> emit,
  ) async {
    emit(state.copyWith(status: SavedStatus.loading));

    final savedFromContracts = contractsBloc.state.savedContracts;
    
    final filtered = filterSavedContractsUseCase(
      contracts: savedFromContracts,
      query: event.query,
      fromDate: event.fromDate,
      toDate: event.toDate,
      statuses: event.statuses,
    );

    emit(state.copyWith(
      status: SavedStatus.success,
      savedContracts: filtered,
    ));
  }

  @override
  Future<void> close() {
    _contractsBlocSubscription.cancel();
    return super.close();
  }
}
