class BidModel {
  final int id;
  final int auctionId;
  final int userId;
  final int bidAmount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  BidModel({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.bidAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'],
      auctionId: json['auction_id'],
      userId: json['user_id'],
      bidAmount: json['bid_amount'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }
}
