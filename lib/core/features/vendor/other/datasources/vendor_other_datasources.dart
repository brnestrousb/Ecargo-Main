import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

abstract class VendorsRemoteDataSource {
  Future<Response> getProfile({
    required String accessToken,
  });
}

class VendorsRemoteDataSourceImpl implements VendorsRemoteDataSource {
  final Dio dio;
  final Logger logger;

  VendorsRemoteDataSourceImpl(this.dio) : logger = Logger();

  @override
  Future<Response> getProfile({
    required String accessToken,
  }) async {
    const String url = '/vendors/get-profile';

    try {
      logger.i('👤 Sending GET request to $url');
      logger.i('🔐 Authorization: Bearer $accessToken');

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        logger.i('✅ Profile fetched successfully');
        logger.i('📥 Response data: ${response.data}');
      } else {
        throw Exception(
            'Failed to fetch profile. Status code: ${response.statusCode}');
      }

      return response;
    } on DioException catch (e) {
      logger.e('❌ GET profile request failed!');
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
