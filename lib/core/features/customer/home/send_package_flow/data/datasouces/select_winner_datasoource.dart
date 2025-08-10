import 'package:dio/dio.dart';
import 'package:ecarrgo/core/network/api_constants.dart';
import 'package:logger/logger.dart';

class SelectWinnerDataSource {
  final Dio dio;
  final Logger logger;

  SelectWinnerDataSource()
      : dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        )),
        logger = Logger();

  Future<void> selectWinner({
    required int auctionId,
    required int vendorId,
    required String accessToken,
  }) async {
    final String url = '/api/v1/auctions/$auctionId/select-winner';

    try {
      logger.i('📦 Selecting winner for Auction ID: $auctionId');
      logger.i('🌐 Full URL: ${dio.options.baseUrl}$url');
      logger.i('👤 Vendor ID: $vendorId');

      final response = await dio.patch(
        url,
        data: {
          "vendor_id": vendorId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('✅ Winner selected successfully');
        logger.i('📥 Response data: ${response.data}');
      } else {
        logger.e(
            '❌ Failed to select winner. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to select winner. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e('❌ Select winner request failed!');
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
