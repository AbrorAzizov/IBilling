import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/contract.dart';
import '../repo/contract_repository.dart';

class GetContractsUseCase {
  final ContractRepository repository;

  GetContractsUseCase(this.repository);

  Future<Either<Failure, List<Contract>>> call({int limit = 3, String? lastId}) {
    return repository.getContracts(limit: limit, lastId: lastId);
  }
}
