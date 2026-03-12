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

