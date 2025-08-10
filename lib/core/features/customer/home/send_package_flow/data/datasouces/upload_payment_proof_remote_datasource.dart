import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class UploadPaymentProofDataSource {
  final Dio dio;
  final Logger logger;

  UploadPaymentProofDataSource(this.dio) : logger = Logger();

  Future<void> uploadPaymentProof({
    required int shipmentId,
    required String filePath,
    required String accessToken,
  }) async {
    final String url = '/upload/file-batch';

    try {
      logger.i('💸 Uploading payment proof to $url');
      logger.i('📦 Shipment ID: $shipmentId');
      logger.i('📁 File path: $filePath');

      final fileName = filePath.split('/').last;

      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      logger.i('📤 FormData: $formData');

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
            'site-password': 'abcdefg',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('✅ Payment proof uploaded successfully');
        logger.i('📥 Response data: ${response.data}');
      } else {
        throw Exception(
          'Failed to upload payment proof. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      logger.e('❌ Payment proof upload failed!');
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
