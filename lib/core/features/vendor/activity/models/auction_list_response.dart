import 'auction_model.dart';
import 'pagination_model.dart';

class AuctionListResponse {
  final List<AuctionModel> data;
  final PaginationModel pagination;

  AuctionListResponse({
    required this.data,
    required this.pagination,
  });

  factory AuctionListResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data']['data'] as List<dynamic>;
    return AuctionListResponse(
      data: dataList.map((e) => AuctionModel.fromJson(e)).toList(),
      pagination: PaginationModel.fromJson(json['data']['pagination']),
    );
  }
}
