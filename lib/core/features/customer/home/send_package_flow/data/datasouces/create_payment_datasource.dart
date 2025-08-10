import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class CreatePaymentDataSource {
  final Dio dio;
  final Logger logger;

  CreatePaymentDataSource(this.dio) : logger = Logger();

  Future<void> createPayment({
    required int shipmentId,
    required int userId,
    required double amount,
    required String paymentMethod,
    required String filePath,
    required String accessToken,
  }) async {
    final String url = '/payments';

    try {
      logger.i('💸 Creating payment at $url');
      logger.i('📦 Shipment ID: $shipmentId');
      logger.i('👤 User ID: $userId');
      logger.i('💰 Amount: $amount');
      logger.i('📁 File path: $filePath');
      logger.i('📄 Payment Method: $paymentMethod');

      final fileName = filePath.split('/').last;

      final payload = {
        'shipment_id': shipmentId,
        'user_id': userId,
        'amount': amount,
        'status': 'pending',
        'payment_method': paymentMethod,
        'transaction_id': fileName, // Gunakan nama file sebagai transaction_id
      };

      logger.i('📤 Payload: $payload');

      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('✅ Payment created successfully');
        logger.i('📥 Response data: ${response.data}');
      } else {
        throw Exception(
          'Failed to create payment. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      logger.e('❌ Payment creation failed!');
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
