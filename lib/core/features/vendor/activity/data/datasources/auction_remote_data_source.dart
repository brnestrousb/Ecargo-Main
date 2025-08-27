import 'package:dio/dio.dart';
import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

abstract class AuctionRemoteDataSource {
  Future<Map<String, dynamic>> getMyAuctions();
  Future<Map<String, dynamic>> getAuctionById(int id);
  Future<Map<String, dynamic>> getMyBids();
}

class AuctionRemoteDataSourceImpl implements AuctionRemoteDataSource {
  final Dio dio;

  AuctionRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getMyAuctions() async {
    final url = '/auctions/my-auctions';

    final token = await SecureStorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      Logger().i(jsonEncode(response.data));
      // langsung return data json mentah tanpa mapping
      return response.data;
    } else {
      throw Exception('Failed to fetch auctions');
    }
  }

  Future<Map<String, dynamic>> getAllAuctions() async {
    final url = '/auctions';
    final token = await SecureStorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      Logger().i('📋 All Auctions: ${jsonEncode(response.data)}');
      return response.data;
    } else {
      throw Exception('Failed to fetch all auctions');
    }
  }

  @override
  Future<Map<String, dynamic>> getAuctionById(int id) async {
    final url = '/auctions/$id';
    final token = await SecureStorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      Logger().i('🔍 Auction $id: ${jsonEncode(response.data)}');
      return response.data;
    } else {
      throw Exception('Failed to fetch auction with id $id');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyBids() async {
    final url = '/auctions/my-bids';
    final token = await SecureStorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      Logger().i('🏷️ My Bids: ${jsonEncode(response.data)}');
      return response.data;
    } else {
      throw Exception('Failed to fetch my bids');
    }
  }
}
