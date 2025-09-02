import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model_vendor.dart';
import 'package:ecarrgo/core/features/vendor/auction/data/models/pagination_model_vendor.dart';

class AuctionListResponse {
  final List<Auction> data;
  final PaginationVendorModel pagination;

  AuctionListResponse({
    required this.data,
    required this.pagination,
  });

  factory AuctionListResponse.fromJson(Map<String, dynamic> json) {
    // Parsing data auctions
    List<Auction> auctions = [];
    if (json['data'] is List) {
      auctions = (json['data'] as List)
          .whereType<Map<String, dynamic>>() // Filter hanya item yang bertipe Map
          .map((itemJson) => Auction.fromJson(itemJson))
          .toList();
    } else {
      // Jika 'data' bukan list (misalnya null atau struktur tidak sesuai), kembalikan list kosong
      auctions = [];
    }

    // Parsing pagination
    PaginationVendorModel pagination;
    if (json['pagination'] is Map<String, dynamic>) {
      pagination = PaginationVendorModel.fromJson(json['pagination']);
    } else {
      // Jika pagination tidak ada atau format salah, buat default
      // Anda perlu memastikan PaginationVendorModel.fromJson bisa handle map kosong
      // atau buat factory PaginationVendorModel.empty()
      pagination = PaginationVendorModel.fromJson({});
    }

    return AuctionListResponse(
      data: auctions,
      pagination: pagination,
    );
  }
}