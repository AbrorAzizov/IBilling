import 'package:equatable/equatable.dart';
import '../../domain/entity/contract.dart';
import '../../domain/entity/invoice.dart';

abstract class CreateEvent extends Equatable {
  const CreateEvent();

  @override
  List<Object?> get props => [];
}

class CreateContractRequested extends CreateEvent {
  final Contract contract;

  const CreateContractRequested(this.contract);

  @override
  List<Object?> get props => [contract];
}

class CreateInvoiceRequested extends CreateEvent {
  final Invoice invoice;

  const CreateInvoiceRequested(this.invoice);

  @override
  List<Object?> get props => [invoice];
}
