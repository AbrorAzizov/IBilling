import 'package:equatable/equatable.dart';
import '../../domain/entity/contract.dart';

abstract class ContractsEvent extends Equatable {
  const ContractsEvent();

  @override
  List<Object?> get props => [];
}

class FetchContractsRequested extends ContractsEvent {}

class LoadMoreContractsRequested extends ContractsEvent {}

class FilterContractsRequested extends ContractsEvent {
  final String? query;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<ContractStatus>? statuses;

  const FilterContractsRequested({
    this.query,
    this.fromDate,
    this.toDate,
    this.statuses,
  });

  @override
  List<Object?> get props => [query, fromDate, toDate, statuses];
}

class DeleteContractRequested extends ContractsEvent {
  final String id;

  const DeleteContractRequested(this.id);

  @override
  List<Object?> get props => [id];
}
