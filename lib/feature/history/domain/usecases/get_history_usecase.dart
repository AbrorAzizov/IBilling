import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../contracts/domain/entity/contract.dart';
import '../repo/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  /// Returns all contracts sorted by newest first
  Future<Either<Failure, List<Contract>>> call() async {
    final result = await repository.getAllContracts();

    return result.map((contracts) {
      final sortedContracts = List<Contract>.from(contracts)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
      return sortedContracts;
    });
  }

  /// Optional: filter contracts by query and date, sorted newest first
  List<Contract> filterContracts({
    required List<Contract> contracts,
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    final filtered = contracts.where((contract) {
      final matchesQuery = query == null || query.isEmpty
          ? true
          : contract.fullName.toLowerCase().contains(query.toLowerCase()) ||
          contract.inn.contains(query);

      final matchesFrom = fromDate == null
          ? true
          : contract.createdAt.isAfter(fromDate.subtract(const Duration(days: 1)));

      final matchesTo = toDate == null
          ? true
          : contract.createdAt.isBefore(toDate.add(const Duration(days: 1)));

      return matchesQuery && matchesFrom && matchesTo;
    }).toList();

    // Always sort newest first
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }
}