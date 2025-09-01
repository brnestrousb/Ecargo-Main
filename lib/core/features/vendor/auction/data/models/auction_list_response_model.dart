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
    final dataList = json['data']['data'] as List<dynamic>;
    return AuctionListResponse(
      data: dataList.map((e) => Auction.fromJson(e)).toList(),
      pagination: PaginationVendorModel.fromJson(json['data']['pagination']),
    );
  }
}