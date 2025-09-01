class Payment {
  final int id;
  final int shipmentId;
  final int userId;
  final double amount;
  final String status;
  final String paymentMethod;
  final String transactionId;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.shipmentId,
    required this.userId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.transactionId,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      shipmentId: json['shipment_id'],
      userId: json['user_id'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shipment_id': shipmentId,
      'user_id': userId,
      'amount': amount,
      'status': status,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
