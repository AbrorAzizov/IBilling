import 'package:equatable/equatable.dart';
import '../../domain/entity/contract.dart';

enum ContractsStatus { initial, loading, success, failure, loadingMore }

class ContractsState extends Equatable {
  final ContractsStatus status;
  final List<Contract> contracts;
  final String? errorMessage;
  final bool hasReachedMax;

  const ContractsState({
    this.status = ContractsStatus.initial,
    this.contracts = const [],
    this.errorMessage,
    this.hasReachedMax = false,
  });

  ContractsState copyWith({
    ContractsStatus? status,
    List<Contract>? contracts,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return ContractsState(
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, contracts, errorMessage, hasReachedMax];
}
