import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/invoice.dart';
import '../repo/create_repository.dart';

class CreateInvoiceUseCase {
  final CreateRepository repository;

  CreateInvoiceUseCase(this.repository);

  Future<Either<Failure, void>> call(Invoice invoice) {
    return repository.createInvoice(invoice);
  }
}
