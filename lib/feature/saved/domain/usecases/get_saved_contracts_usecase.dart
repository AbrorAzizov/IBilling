import '../../../new/domain/entity/contract.dart';

class GetSavedContractsUseCase {
  GetSavedContractsUseCase();

  /// Sort saved contracts by creation date (newest first)
  ///
  /// Note: The contracts passed to this method are already known to be saved
  /// (they come from ContractsBloc.state.savedContracts).
  /// This method only handles sorting logic.
  List<Contract> getSavedContractsFromList(List<Contract> contracts) {
    final sorted = List.of(contracts);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }
}


