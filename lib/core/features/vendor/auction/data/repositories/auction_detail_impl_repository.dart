// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model_vendor.dart';
// import 'package:ecarrgo/core/features/vendor/auction/data/models/bid_model_vendor.dart';
// import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
// import 'package:logger/logger.dart';
// import 'auction_detail_repository.dart';

// class AuctionDetailRepositoryImpl implements AuctionDetailRepository {
//   final Dio dio;
//   final String baseUrl;

//   AuctionDetailRepositoryImpl({
//     required this.dio,
//     required this.baseUrl,
//   });

//   @override
//   Future<Auction> fetchAuctionDetail(int auctionId) async {
//     final url = '/auctions/my-auctions';

//     final token = await SecureStorageService().getToken();

//     if (token == null) {
//       throw Exception('Token tidak ditemukan, silakan login ulang');
//     }

//     final response = await dio.get(
//       url,
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       ),
//     );

//     if (response.statusCode == 200 && response.data['success'] == true) {
//       Logger().i(jsonEncode(response.data));
//       // langsung return data json mentah tanpa mapping
//       return response.data;
//     } else {
//       throw Exception('Failed to fetch auctions');
//     }
//   }

//   @override
//   Future<Bid> placeBid(int auctionId, double amount) async {
//     final url = '/auctions/my-bids';
//     final token = await SecureStorageService().getToken();

//     if (token == null) {
//       throw Exception('Token tidak ditemukan, silakan login ulang');
//     }

//     final response = await dio.get(
//       url,
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       ),
//     );

//     if (response.statusCode == 200 && response.data['success'] == true) {
//       Logger().i('🏷️ My Bids: ${jsonEncode(response.data)}');
//       return response.data;
//     } else {
//       throw Exception('Failed to fetch my bids');
//     }
//   }
// }
