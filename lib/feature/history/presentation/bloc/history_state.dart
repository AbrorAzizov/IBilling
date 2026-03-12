import 'package:equatable/equatable.dart';
import '../../../contracts/domain/entity/contract.dart';

enum HistoryStatus { initial, loading, success, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<Contract> contracts;
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.contracts = const [],
    this.errorMessage,
  });

  HistoryState copyWith({
    HistoryStatus? status,
    List<Contract>? contracts,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, contracts, errorMessage];
}
