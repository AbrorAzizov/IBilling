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
    List<ContractStatus>? statuses,
  }) async {
    try {
      final contracts = await remoteDataSource.filterContracts(
        query: query,
        fromDate: fromDate,
        toDate: toDate,
        statuses: statuses,
      );
      return Right(contracts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContract(String id) async {
    try {
      await remoteDataSource.deleteContract(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
