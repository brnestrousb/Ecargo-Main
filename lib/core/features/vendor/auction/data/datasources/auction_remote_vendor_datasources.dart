import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
import 'package:logger/logger.dart';

abstract class AuctionRemoteVendorDataSource {
  Future<Map<String, dynamic>> getMyAuctions();
  Future<Map<String, dynamic>> getAuctionById(int id);
  Future<Map<String, dynamic>> getMyBids();
  Future<Map<String, dynamic>> getAllAuctions();
}

class AuctionRemoteVendorDataSourceImpl
    implements AuctionRemoteVendorDataSource {
  final Dio dio;

  AuctionRemoteVendorDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getMyAuctions() async {
    final url = '/auctions/my-auctions';
    final token = await SecureStorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // 🔍 Validasi struktur data
        if (response.data is Map<String, dynamic>) {
          Logger().i(jsonEncode(response.data));
          return response.data;
        } else {
          throw Exception(
              'Invalid response format: expected Map<String, dynamic>');
        }
      } else {
        throw Exception(
            'Failed to fetch my auctions: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      Logger().e('❌ Dio Error fetch my auctions: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      Logger().e('❌ Error fetch my auctions: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getAllAuctions() async {
    final url = '/auctions';
    final token = await SecureStorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // 🔍 Validasi struktur data
        if (response.data is Map<String, dynamic>) {
          Logger().i(jsonEncode(response.data));
          return response.data;
        } else {
          throw Exception(
              'Invalid response format: expected Map<String, dynamic>');
        }
      } else {
        throw Exception(
            'Failed to fetch all auctions: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      Logger().e('❌ Dio Error fetch all auctions: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      Logger().e('❌ Error fetch all auctions: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getAuctionById(int id) async {
    final url = '/auctions/$id';
    final token = await SecureStorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // 🔍 Validasi struktur data
        if (response.data is Map<String, dynamic>) {
          Logger().i(jsonEncode(response.data));
          return response.data;
        } else {
          throw Exception(
              'Invalid response format: expected Map<String, dynamic>');
        }
      } else {
        throw Exception(
            'Failed to fetch auction with id $id: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      Logger().e('❌ Dio Error fetch auction $id: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      Logger().e('❌ Error fetch auction $id: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getMyBids() async {
    final url = '/auctions/my-bids';
    final token = await SecureStorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login ulang');
    }

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // 🔍 Validasi struktur data
        if (response.data is Map<String, dynamic>) {
          Logger().i('🏷️ My Bids: ${jsonEncode(response.data)}');
          return response.data;
        } else {
          throw Exception(
              'Invalid response format: expected Map<String, dynamic>');
        }
      } else {
        throw Exception('Failed to fetch my bids: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      Logger().e('❌ Dio Error fetch my bids: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      Logger().e('❌ Error fetch my bids: $e');
      rethrow;
    }
  }
}
