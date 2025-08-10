import 'package:ecarrgo/core/features/customer/activity/data/models/shipment_model.dart';

class AuctionModel {
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

  AuctionModel({
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
    // null or empty map => null
    if (date == null) return null;
    if (date is Map && date.isEmpty) return null;

    // if string and not empty, try parse
    if (date is String && date.isNotEmpty) {
      return DateTime.tryParse(date);
    }

    return null;
  }

  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['id'] ?? 0,
      shipmentId: json['shipment_id'] ?? 0,
      vendorId: json['vendor_id'] ?? 0,
      startingBid: json['starting_bid'] ?? 0,
      auctionStartingPrice: json['auction_starting_price'] ?? '',
      auctionDuration: json['auction_duration'] ?? '',
      status: json['status'] ?? '',
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      deletedAt: parseDate(json['deleted_at']),
      expiresAt: parseDate(json['expires_at']),
      shipment: ShipmentModel.fromJson(json['shipment'] ?? {}),
      bids: json['bids'] ?? [],
    );
  }
}
