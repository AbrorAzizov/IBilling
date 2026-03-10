import 'package:equatable/equatable.dart';

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

  const FilterContractsRequested({
    this.query,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [query, fromDate, toDate];
}
