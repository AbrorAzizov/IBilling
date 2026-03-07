import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_contract_usecase.dart';
import '../../domain/usecases/create_invoice_usecase.dart';
import 'create_event.dart';
import 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  final CreateContractUseCase createContractUseCase;
  final CreateInvoiceUseCase createInvoiceUseCase;

  CreateBloc({
    required this.createContractUseCase,
    required this.createInvoiceUseCase,
  }) : super(const CreateState()) {
    on<CreateContractRequested>(_onCreateContractRequested);
    on<CreateInvoiceRequested>(_onCreateInvoiceRequested);
  }

  Future<void> _onCreateContractRequested(
    CreateContractRequested event,
    Emitter<CreateState> emit,
  ) async {
    emit(state.copyWith(status: CreateStatus.loading));
    
    final result = await createContractUseCase(event.contract);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: CreateStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: CreateStatus.success)),
    );
  }

  Future<void> _onCreateInvoiceRequested(
    CreateInvoiceRequested event,
    Emitter<CreateState> emit,
  ) async {
    emit(state.copyWith(status: CreateStatus.loading));
    
    final result = await createInvoiceUseCase(event.invoice);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CreateStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: CreateStatus.success)),
    );
  }
}
