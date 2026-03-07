import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/contract_model.dart';
import '../model/invoice_model.dart';

abstract class CreateRemoteDataSource {
  Future<void> createContract(ContractModel contract);
  Future<void> createInvoice(InvoiceModel invoice);
}

class CreateRemoteDataSourceImpl implements CreateRemoteDataSource {
  final FirebaseFirestore firestore;

  CreateRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createContract(ContractModel contract) async {
    try {
      await firestore
          .collection("contracts")
          .doc(contract.id)
          .set(contract.toJson());
    } on FirebaseException catch (e) {
      throw Exception(_handleFirebaseError(e));
    } catch (e) {
      throw Exception('Unexpected error while creating contract');
    }
  }

  @override
  Future<void> createInvoice(InvoiceModel invoice) async {
    try {
      await firestore
          .collection("invoices")
          .doc(invoice.id)
          .set(invoice.toJson());
    } on FirebaseException catch (e) {
      throw Exception(_handleFirebaseError(e));
    } catch (e) {
      throw Exception('Unexpected error while creating invoice');
    }
  }

  String _handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Permission denied';

      case 'not-found':
        return 'Document not found';

      case 'already-exists':
        return 'Document already exists';

      case 'unavailable':
        return 'Service temporarily unavailable';

      default:
        return e.message ?? 'Firebase error occurred';
    }
  }
}