import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/contract.dart';
import '../../domain/repo/contract_repository.dart';
import '../datasources/contract_remote_datasource.dart';

class ContractRepositoryImpl implements ContractRepository {
  final ContractRemoteDataSource remoteDataSource;

  ContractRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Contract>>> getContracts({
    int limit = 3,
    String? lastId,
  }) async {
    try {
      final contracts = await remoteDataSource.getContracts(
        limit: limit,
        lastCreatedAt: lastId,
      );
      return Right(contracts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Contract>>> filterContracts({
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final contracts = await remoteDataSource.filterContracts(
        query: query,
        fromDate: fromDate,
        toDate: toDate,
      );
      return Right(contracts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
