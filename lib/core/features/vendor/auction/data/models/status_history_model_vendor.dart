class StatusHistory {
  final int id;
  final int shipmentId;
  final String status;
  final String remarks;
  final DateTime changedAt;

  StatusHistory({
    required this.id,
    required this.shipmentId,
    required this.status,
    required this.remarks,
    required this.changedAt,
  });

  factory StatusHistory.fromJson(Map<String, dynamic> json) {
    return StatusHistory(
      id: json['id'],
      shipmentId: json['shipment_id'],
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
      changedAt: DateTime.parse(json['changed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shipment_id': shipmentId,
      'status': status,
      'remarks': remarks,
      'changed_at': changedAt.toIso8601String(),
    };
  }
}
