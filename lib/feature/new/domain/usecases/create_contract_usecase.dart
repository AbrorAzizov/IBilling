import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/contract.dart';
import '../repo/create_repository.dart';

class CreateContractUseCase {
  final CreateRepository repository;

  CreateContractUseCase(this.repository);

  Future<Either<Failure, void>> call(Contract contract) {
    return repository.createContract(contract);
  }
}
