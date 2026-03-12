import 'package:equatable/equatable.dart';

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

  const FilterHistoryRequested({
    this.query,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [query, fromDate, toDate];
}
