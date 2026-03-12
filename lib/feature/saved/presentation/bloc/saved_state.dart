import 'package:equatable/equatable.dart';
import '../../../contracts/domain/entity/contract.dart';

enum SavedStatus { initial, loading, success, failure, loadingMore }

class SavedState extends Equatable {
  final SavedStatus status;
  final List<Contract> savedContracts;
  final String? errorMessage;
  final bool hasReachedMax;

  const SavedState({
    this.status = SavedStatus.initial,
    this.savedContracts = const [],
    this.errorMessage,
    this.hasReachedMax = false,
  });

  SavedState copyWith({
    SavedStatus? status,
    List<Contract>? savedContracts,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return SavedState(
      status: status ?? this.status,
      savedContracts: savedContracts ?? this.savedContracts,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, savedContracts, errorMessage, hasReachedMax];
}

