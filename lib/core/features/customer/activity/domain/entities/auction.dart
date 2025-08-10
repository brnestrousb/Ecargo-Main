import 'package:ecarrgo/core/features/customer/activity/data/models/shipment_model.dart';

class Auction {
  final int id;
  final int shipmentId;
  final int vendorId;
  final int startingBid;
  final String auctionStartingPrice;
  final String auctionDuration;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? expiresAt;
  final ShipmentModel shipment;
  final List<dynamic> bids;

  Auction({
    required this.id,
    required this.shipmentId,
    required this.vendorId,
    required this.startingBid,
    required this.auctionStartingPrice,
    required this.auctionDuration,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.expiresAt,
    required this.shipment,
    required this.bids,
  });

  static DateTime? parseDate(dynamic date) {
    if (date == null) return null;
    if (date is String && date.isNotEmpty) {
      return DateTime.tryParse(date);
    }
    // Kalau bukan string, misal Map atau lainnya, return null
    return null;
  }

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'],
      shipmentId: json['shipment_id'],
      vendorId: json['vendor_id'],
      startingBid: json['starting_bid'],
      auctionStartingPrice: json['auction_starting_price'],
      auctionDuration: json['auction_duration'],
      status: json['status'],
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      deletedAt: parseDate(json['deleted_at']),
      expiresAt: parseDate(json['expires_at']),
      shipment: ShipmentModel.fromJson(json['shipment']),
      bids: json['bids'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shipment_id': shipmentId,
      'vendor_id': vendorId,
      'starting_bid': startingBid,
      'auction_starting_price': auctionStartingPrice,
      'auction_duration': auctionDuration,
      'status': status,
      'created_at': createdAt?.toIso8601String() ?? '',
      'updated_at': updatedAt?.toIso8601String() ?? '',
      'deleted_at': deletedAt?.toIso8601String() ?? '',
      'expires_at': expiresAt?.toIso8601String() ?? '',
      'shipment': shipment.toJson(),
      'bids': bids,
    };
  }
}
