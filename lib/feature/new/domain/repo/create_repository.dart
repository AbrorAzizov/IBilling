import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/contract.dart';
import '../entity/invoice.dart';

abstract class CreateRepository {
  Future<Either<Failure, void>> createContract(Contract contract);
  Future<Either<Failure, void>> createInvoice(Invoice invoice);
}
