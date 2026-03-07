class Contract {
  final String id;

  /// Physical or Legal person
  final ContractPersonType personType;

  /// Fisher's full name
  final String fullName;

  /// Address of the organization
  final String address;

  /// Tax number
  final String inn;

  /// Contract status
  final ContractStatus status;

  /// Creation date
  final DateTime createdAt;

  Contract({
    required this.id,
    required this.personType,
    required this.fullName,
    required this.address,
    required this.inn,
    required this.status,
    required this.createdAt,
  });
}

enum ContractPersonType { physical, legal }

enum ContractStatus { paid, inProcess, rejectedByPayme, rejectedByIQ }
