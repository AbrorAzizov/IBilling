import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../contracts/data/model/contract_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<ContractModel>> getAllContracts();
  Future<void> deleteContract(String id);
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

  @override
  Future<void> deleteContract(String id) async {
    try {
      await firestore.collection('contracts').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete contract in history: $e');
    }
  }
}
