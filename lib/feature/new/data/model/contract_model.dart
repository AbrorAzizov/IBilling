import '../../domain/entity/contract.dart';

class ContractModel extends Contract {
  ContractModel({
    required super.id,
    required super.personType,
    required super.fullName,
    required super.address,
    required super.inn,
    required super.status,
    required super.createdAt,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json["id"],
      personType: json["personType"] == "physical"
          ? ContractPersonType.physical
          : ContractPersonType.legal,
      fullName: json["fullName"],
      address: json["address"],
      inn: json["inn"],
      status: _statusFromString(json["status"]),
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "personType": personType.name,
      "fullName": fullName,
      "address": address,
      "inn": inn,
      "status": status.name,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  static ContractStatus _statusFromString(String status) {
    switch (status) {
      case "paid":
        return ContractStatus.paid;
      case "inProcess":
        return ContractStatus.inProcess;
      case "rejectedByPayme":
        return ContractStatus.rejectedByPayme;
      case "rejectedByIQ":
        return ContractStatus.rejectedByIQ;
      default:
        return ContractStatus.inProcess;
    }
  }
}