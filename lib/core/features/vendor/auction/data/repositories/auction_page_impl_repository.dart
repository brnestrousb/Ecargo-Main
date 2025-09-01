// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model_vendor.dart';
// import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
// import 'package:logger/logger.dart';
// import 'auction_page_repository.dart';

// /// Implementasi AuctionPageRepository dengan Dio
// class AuctionPageRepositoryImpl implements AuctionPageRepository {
//   final Dio dio;
//   final String baseUrl;

//   AuctionPageRepositoryImpl({
//     required this.dio,
//     required this.baseUrl,
//   });

//   @override
//   Future<List<Auction>> getAuctions() async {
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
//   Future<Auction> getAuctionDetail(int id) async {
//     final url = '/auctions';
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
//       Logger().i('📋 All Auctions: ${jsonEncode(response.data)}');
//       return response.data;
//     } else {
//       throw Exception('Failed to fetch all auctions');
//     }
//   }
// }
