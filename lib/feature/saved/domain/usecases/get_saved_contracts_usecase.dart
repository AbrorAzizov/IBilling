import '../../../new/domain/entity/contract.dart';

class GetSavedContractsUseCase {
  List<Contract> call(List<Contract> contracts) {
    final sorted = List<Contract>.from(contracts);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }
}
