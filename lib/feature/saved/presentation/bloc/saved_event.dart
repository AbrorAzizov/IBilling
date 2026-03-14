import 'package:equatable/equatable.dart';
import '../../../contracts/domain/entity/contract.dart';

abstract class SavedEvent extends Equatable {
  const SavedEvent();

  @override
  List<Object?> get props => [];
}

class FetchSavedContractsRequested extends SavedEvent {
  const FetchSavedContractsRequested();
}

class FilterSavedContractsRequested extends SavedEvent {
  final String? query;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<ContractStatus>? statuses;

  const FilterSavedContractsRequested({
    this.query,
    this.fromDate,
    this.toDate,
    this.statuses,
  });

  @override
  List<Object?> get props => [query, fromDate, toDate, statuses];
}

class DeleteSavedContractRequested extends SavedEvent {
  final String id;

  const DeleteSavedContractRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class RemoveSavedContractRequested extends SavedEvent {
  final String id;

  const RemoveSavedContractRequested(this.id);

  @override
  List<Object?> get props => [id];
}
