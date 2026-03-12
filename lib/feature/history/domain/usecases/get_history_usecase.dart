import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../contracts/domain/entity/contract.dart';
import '../repo/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  Future<Either<Failure, List<Contract>>> call() {
    return repository.getAllContracts();
  }
}
