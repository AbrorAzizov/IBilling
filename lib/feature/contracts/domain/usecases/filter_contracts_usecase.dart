import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/contract.dart';
import '../repo/contract_repository.dart';

class FilterContractsUseCase {
  final ContractRepository repository;

  FilterContractsUseCase(this.repository);

  Future<Either<Failure, List<Contract>>> call({
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
    List<ContractStatus>? statuses,
  }) async {
    final result = await repository.filterContracts(
      query: query,
      fromDate: fromDate,
      toDate: toDate,
      statuses: statuses,
    );

    return result.map((contracts) {
      final sorted = List<Contract>.from(contracts);
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return sorted;
    });
  }
}
