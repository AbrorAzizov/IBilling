import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/contract.dart';

abstract class ContractRepository {
  Future<Either<Failure, List<Contract>>> getContracts({int limit = 3, String? lastId});
  Future<Either<Failure, List<Contract>>> filterContracts({
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
    List<ContractStatus>? statuses,
  });
}
