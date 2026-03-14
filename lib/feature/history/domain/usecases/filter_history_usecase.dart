import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../contracts/domain/entity/contract.dart';
import '../repo/history_repository.dart';

class FilterHistoryUseCase {
  final HistoryRepository repository;

  FilterHistoryUseCase(this.repository);

  Future<Either<Failure, List<Contract>>> call({
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
    List<ContractStatus>? statuses,
  }) async {
    final result = await repository.getAllContracts();

    return result.map((contracts) {
      final filtered = contracts.where((contract) {
        final matchesQuery = query == null || query.isEmpty
            ? true
            : contract.fullName.toLowerCase().contains(query.toLowerCase()) ||
                contract.id.contains(query);

        final matchesFrom = fromDate == null
            ? true
            : contract.createdAt.isAfter(fromDate!);

        final matchesTo = toDate == null
            ? true
            : contract.createdAt.isBefore(toDate!.add(const Duration(days: 1)));

        final matchesStatus = statuses == null || statuses.isEmpty
            ? true
            : statuses.contains(contract.status);

        return matchesQuery && matchesFrom && matchesTo && matchesStatus;
      }).toList();

      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filtered;
    });
  }
}
