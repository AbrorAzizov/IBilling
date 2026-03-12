import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistoryUseCase;

  HistoryBloc({
    required this.getHistoryUseCase,
  }) : super(const HistoryState()) {
    on<FetchHistoryRequested>(_onFetchHistoryRequested);
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
}
