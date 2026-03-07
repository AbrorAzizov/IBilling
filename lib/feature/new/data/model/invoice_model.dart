
import '../../domain/entity/invoice.dart';

class InvoiceModel extends Invoice {
  InvoiceModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.status,
    required super.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: _statusFromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'status': status.name, // enum → string
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static InvoiceStatus _statusFromString(String status) {
    switch (status) {
      case 'paid':
        return InvoiceStatus.paid;
      case 'pending':
        return InvoiceStatus.pending;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      default:
        return InvoiceStatus.pending;
    }
  }
}