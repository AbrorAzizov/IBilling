import 'package:equatable/equatable.dart';
import '../../../contracts/domain/entity/contract.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchHistoryRequested extends HistoryEvent {}

class FilterHistoryRequested extends HistoryEvent {
  final String? query;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<ContractStatus>? statuses;

  const FilterHistoryRequested({
    this.query,
    this.fromDate,
    this.toDate,
    this.statuses,
  });

  @override
  List<Object?> get props => [query, fromDate, toDate, statuses];
}

class DeleteHistoryContractRequested extends HistoryEvent {
  final String id;

  const DeleteHistoryContractRequested(this.id);

  @override
  List<Object?> get props => [id];
}
