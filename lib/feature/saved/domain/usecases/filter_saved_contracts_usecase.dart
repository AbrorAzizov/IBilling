import '../../../contracts/domain/entity/contract.dart';

class FilterSavedContractsUseCase {
  List<Contract> call({
    required List<Contract> contracts,
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
    List<ContractStatus>? statuses,
  }) {
    final filtered = contracts.where((contract) {
      final matchesQuery = query == null || query.isEmpty
          ? true
          : contract.fullName.toLowerCase().contains(query.toLowerCase()) ||
              contract.id.contains(query);

      final matchesFrom = fromDate == null
          ? true
          : contract.createdAt.isAfter(fromDate);

      final matchesTo = toDate == null
          ? true
          : contract.createdAt.isBefore(toDate.add(const Duration(days: 1)));

      final matchesStatus = statuses == null || statuses.isEmpty
          ? true
          : statuses.contains(contract.status);

      return matchesQuery && matchesFrom && matchesTo && matchesStatus;
    }).toList();

    // Sort newest first
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }
}
