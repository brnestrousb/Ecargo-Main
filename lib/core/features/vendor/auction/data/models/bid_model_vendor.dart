import 'package:ecarrgo/core/features/vendor/auction/data/models/user_model.dart';

class Bid {
  final int id;
  final int auctionId;
  final int userId;
  final double bidAmount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  Bid({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.bidAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
  return Bid(
    id: json['id'] is String ? int.parse(json['id']) : json['id'],
    auctionId: json['auction_id'] is String ? int.parse(json['auction_id']) : json['auction_id'],
    userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
    bidAmount: double.tryParse(json['bid_amount'].toString()) ?? 0.0,
    status: json['status'] ?? '',
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    user: User.fromJson(json['user']),
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auction_id': auctionId,
      'user_id': userId,
      'bid_amount': bidAmount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}
