import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../contracts/domain/entity/contract.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<Contract>>> getAllContracts();
}
