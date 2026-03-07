import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/contract.dart';
import '../../domain/entity/invoice.dart';
import '../../domain/repo/create_repository.dart';
import '../datasources/create_remote_datasource.dart';
import '../model/contract_model.dart';
import '../model/invoice_model.dart';

class CreateRepositoryImpl implements CreateRepository {
  final CreateRemoteDataSource remoteDataSource;

  CreateRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createContract(Contract contract) async {
    try {
      final model = ContractModel(
        id: contract.id,
        personType: contract.personType,
        fullName: contract.fullName,
        address: contract.address,
        inn: contract.inn,
        status: contract.status,
        createdAt: contract.createdAt,
      );

      await remoteDataSource.createContract(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createInvoice(Invoice invoice) async {
    try {
      final model = InvoiceModel(
        id: invoice.id,
        title: invoice.title,
        amount: invoice.amount,
        status: invoice.status,
        createdAt: invoice.createdAt,
      );

      await remoteDataSource.createInvoice(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
