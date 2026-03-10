import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/contract_model.dart';

abstract class ContractRemoteDataSource {
  Future<List<ContractModel>> getContracts({int limit = 3, String? lastCreatedAt});
  Future<List<ContractModel>> filterContracts({
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
  });
}

class ContractRemoteDataSourceImpl implements ContractRemoteDataSource {
  final FirebaseFirestore firestore;

  ContractRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ContractModel>> getContracts({int limit = 3, String? lastCreatedAt}) async {
    try {
      Query query = firestore
          .collection('contracts')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastCreatedAt != null) {
        query = query.startAfter([lastCreatedAt]);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => ContractModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch contracts: $e');
    }
  }

  @override
  Future<List<ContractModel>> filterContracts({
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      Query<Map<String, dynamic>> baseQuery = firestore.collection('contracts');

      if (fromDate != null) {
        baseQuery = baseQuery.where('createdAt',
            isGreaterThanOrEqualTo: fromDate.toIso8601String());
      }

      if (toDate != null) {
        baseQuery = baseQuery.where('createdAt',
            isLessThanOrEqualTo: toDate.toIso8601String());
      }

      final snapshot = await baseQuery.get();
      var contracts = snapshot.docs
          .map((doc) => ContractModel.fromJson(doc.data()))
          .toList();

      if (query != null && query.isNotEmpty) {
        contracts = contracts
            .where((c) =>
                c.fullName.toLowerCase().contains(query.toLowerCase()) ||
                c.inn.contains(query))
            .toList();
      }

      return contracts;
    } catch (e) {
      throw Exception('Failed to filter contracts: $e');
    }
  }
}
