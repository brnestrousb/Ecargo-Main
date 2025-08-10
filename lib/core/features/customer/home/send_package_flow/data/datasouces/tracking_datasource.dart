import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:ecarrgo/core/network/api_constants.dart'; // Import ApiConstants

class TrackingDataSource {
  final Dio dio;
  final Logger logger;

  TrackingDataSource()
      : dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl, // Gunakan base URL dari ApiConstants
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        )),
        logger = Logger();

  Future<Map<String, dynamic>> getRealtimeTrackingUpdates({
    required String resiNumber,
    required String accessToken, // Tambahkan parameter accessToken
  }) async {
    final String url = '/guest/api/v1/tracking/resi/$resiNumber';

    try {
      logger.i('📦 Fetching tracking updates for Resi: $resiNumber');
      logger.i('🌐 Full URL: ${dio.options.baseUrl}$url'); // Log URL lengkap

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken', // Tambahkan access token
            'Content-Type': 'application/json',
            'Accept': 'application/json, text/plain, */*',
          },
        ),
      );

      if (response.statusCode == 200) {
        logger.i('✅ Tracking updates fetched successfully');
        logger.i('📥 Response data: ${response.data}');
        return Map<String, dynamic>.from(response.data);
      } else {
        logger.e(
            '❌ Failed to fetch tracking updates. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to fetch tracking updates. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('❌ Tracking updates fetch failed!');
      if (e.response != null) {
        logger.e('🧾 Status code: ${e.response?.statusCode}');
        logger.e('📄 Response data: ${e.response?.data}');
      } else {
        logger.e('⚠️ Error: ${e.message}');
      }
      rethrow;
    } catch (e) {
      logger.e('🔥 Unexpected error: $e');
      rethrow;
    }
  }
}
