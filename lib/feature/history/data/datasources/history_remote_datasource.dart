import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../contracts/data/model/contract_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<ContractModel>> getAllContracts();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseFirestore firestore;

  HistoryRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ContractModel>> getAllContracts() async {
    try {
      final snapshot = await firestore
          .collection('contracts')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ContractModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch history: $e');
    }
  }
}
