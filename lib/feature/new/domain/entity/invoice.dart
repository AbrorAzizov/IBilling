enum InvoiceStatus {
  paid,
  pending,
  cancelled,
}

class Invoice {
  final String id;
  final String title;
  final double amount;
  final InvoiceStatus status;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.createdAt,
  });
}