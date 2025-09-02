import 'shipment_model_vendor.dart';
import 'vendor_model.dart';
import 'bid_model_vendor.dart';

class Auction {
  final int id;
  final int shipmentId;
  final int? vendorId;
  final double startingBid;
  final double auctionStartingPrice;
  final String auctionDuration;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime expiresAt;

  final Shipment shipment;
  final Vendor? vendor;
  final List<Bid> bids;

  Auction({
    required this.id,
    required this.shipmentId,
    this.vendorId,
    required this.startingBid,
    required this.auctionStartingPrice,
    required this.auctionDuration,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.expiresAt,
    required this.shipment,
    this.vendor,
    required this.bids,
  });

  // Parsing dari JSON
  factory Auction.fromJson(Map<String, dynamic> json) {
    // Helper untuk parsing DateTime dengan fallback
    DateTime parseDateTime(String? dateString, DateTime fallback) {
      if (dateString == null) return fallback;
      return DateTime.tryParse(dateString) ?? fallback;
    }

    return Auction(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      shipmentId: json['shipment_id'] is String
          ? int.parse(json['shipment_id'])
          : json['shipment_id'],
      vendorId: json['vendor_id'] is String 
          ? int.parse(json['vendor_id']) 
          : json['vendor_id'],
      startingBid: double.tryParse(json['starting_bid']?.toString() ?? '') ?? 0.0,
      auctionStartingPrice: double.tryParse(json['auctionStartingPrice']?.toString() ?? '') ?? 0.0,
      auctionDuration: json['auction_duration'] ?? '',
      status: json['status'] ?? '',
      // Gunakan helper dengan tryParse
      createdAt: parseDateTime(json['created_at'], DateTime.now()),
      updatedAt: parseDateTime(json['updated_at'], DateTime.now()),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at']) // Bisa tetap seperti ini atau pakai _parseDateTime
          : null,
      expiresAt: parseDateTime(json['expires_at'], DateTime.now()),
      shipment: json['shipment'] != null
          ? Shipment.fromJson(json['shipment'])
          : Shipment.empty(),
      vendor: json['vendor'] != null
          ? Vendor.fromJson(json['vendor'])
          : Vendor.empty(),
      bids: json['bids'] is List<dynamic>
          ? (json['bids'] as List<dynamic>).map((e) => Bid.fromJson(e)).toList()
          : [],
      // bids: _parseBids(json['bids']),
    );
  }

// Fungsi terpisah untuk parsing bids yang aman
  // static List<Bid> _parseBids(dynamic bidsData) {
  //   if (bidsData == null) return [];

  //   // Jika bids adalah list langsung
  //   if (bidsData is List<dynamic>) {
  //     return bidsData.map((e) => Bid.fromJson(e)).toList();
  //   }

  //   // Jika bids adalah objek dengan properti 'data'
  //   if (bidsData is Map<String, dynamic>) {
  //     final data = bidsData['data'];
  //     if (data is List<dynamic>) {
  //       return data.map((e) => Bid.fromJson(e)).toList();
  //     }
  //   }

  //   return [];
  // }

//   factory Auction.fromJson(Map<String, dynamic> json) {
//   return Auction(
//     id: json['id'] is String ? int.parse(json['id']) : json['id'],
//     shipmentId: json['shipment_id'] is String
//         ? int.parse(json['shipment_id'])
//         : json['shipment_id'],
//     vendorId: json['vendor_id'] is String
//         ? int.parse(json['vendor_id'])
//         : json['vendor_id'],
//     startingBid: double.tryParse(json['starting_bid'].toString()) ?? 0.0,
//     auctionStartingPrice: json['auction_starting_price'] ?? '',
//     auctionDuration: json['auction_duration'] ?? '',
//     status: json['status'] ?? '',
//     createdAt: DateTime.parse(json['created_at']),
//     updatedAt: DateTime.parse(json['updated_at']),
//     deletedAt: json['deleted_at'] != null
//         ? DateTime.tryParse(json['deleted_at'])
//         : null,
//     expiresAt: DateTime.parse(json['expires_at']),
//     shipment: Shipment.fromJson(json['shipment']),
//     vendor: Vendor.fromJson(json['vendor']),
//     bids: json['bids'] is List<dynamic>
//         ? (json['bids'] as List<dynamic>)
//             .map((e) => Bid.fromJson(e))
//             .toList()
//         : [],
//   );
// }
  // factory Auction.fromJson(Map<String, dynamic> json) {
  //   return Auction(
  //     id: json['id'] is String
  //         ? int.parse(json['id'])
  //         : json['id'],
  //     shipmentId: json['shipment_id'] is String
  //         ? int.parse(json['shipment_id'])
  //         : json['shipment_id'],
  //     vendorId: json['vendor_id'] is String
  //         ? int.parse(json['vendor_id'])
  //         : json['vendor_id'],
  //     startingBid: double.tryParse(json['starting_bid'].toString()) ?? 0.0,
  //     auctionStartingPrice: json['auction_starting_price'] ?? '',
  //     auctionDuration: json['auction_duration'] ?? '',
  //     status: json['status'],
  //     createdAt: DateTime.parse(json['created_at']),
  //     updatedAt: DateTime.parse(json['updated_at']),
  //     deletedAt: json['deleted_at'] != null
  //         ? DateTime.tryParse(json['deleted_at'])
  //         : null,
  //     expiresAt: DateTime.parse(json['expires_at']),
  //     shipment: Shipment.fromJson(json['shipment']),
  //     vendor: Vendor.fromJson(json['vendor']),
  //     bids: (json['bids'] as List<dynamic>? ?? [])
  //         .map((e) => Bid.fromJson(e))
  //         .toList(),
  //   );
  // }

  // Convert kembali ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shipment_id': shipmentId,
      'vendor_id': vendorId,
      'starting_bid': startingBid,
      'auction_starting_price': auctionStartingPrice,
      'auction_duration': auctionDuration,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'shipment': shipment.toJson(),
      'vendor': vendor?.toJson(),
      'bids': bids.map((e) => e.toJson()).toList(),
    };
  }
}
