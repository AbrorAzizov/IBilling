import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../contracts/domain/entity/contract.dart';
import '../../domain/repo/history_repository.dart';
import '../datasources/history_remote_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Contract>>> getAllContracts() async {
    try {
      final contracts = await remoteDataSource.getAllContracts();
      return Right(contracts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
