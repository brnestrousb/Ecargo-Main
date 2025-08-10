import 'package:dio/dio.dart';
import 'package:ecarrgo/core/providers/fill_data_provider.dart';
import 'package:ecarrgo/core/providers/shipment_provider.dart';
import 'package:logger/logger.dart';

abstract class SendPackageRemoteDataSource {
  /// Mengirim data paket lelang ke server
  Future<void> createAuctionPackage({
    required Map<String, dynamic> packageData,
    required String accessToken,
  });
}

class SendPackageRemoteDataSourceImpl implements SendPackageRemoteDataSource {
  final Dio dio;
  final Logger logger;
  final ShipmentProvider shipmentProvider; // tambahkan ini
  final FillDataProvider fillDataProvider;

  SendPackageRemoteDataSourceImpl(
      this.dio, this.shipmentProvider, this.fillDataProvider)
      : logger = Logger();

  @override
  Future<(int auctionId, int shipmentId)> createAuctionPackage({
    required Map<String, dynamic> packageData,
    required String accessToken,
  }) async {
    const String url = '/auctions';

    try {
      logger.i('📦 Sending POST request to $url');
      logger.i('🔐 Authorization: Bearer $accessToken');
      logger.i('📤 Body: $packageData');

      final response = await dio.post(
        url,
        data: packageData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('✅ Response status: ${response.statusCode}');
        logger.i('📥 Response data: ${response.data}');

        // Extract data
        final auctionJson = response.data['data']['auction'];
        final shipmentJson = response.data['data']['shipment'];

        final int auctionId = auctionJson['id'];
        final int shipmentId = shipmentJson['id'];
        final String resiNumber = shipmentJson['resi_number'];

        // Simpan ke provider
        shipmentProvider.setShipmentData(
            id: shipmentId, resiNumber: resiNumber);
        fillDataProvider.auctionId = auctionId;

        logger.i('✅ Auction ID: $auctionId, Shipment ID: $shipmentId');
        return (auctionId, shipmentId); // ✅ Return tuple
      } else {
        throw Exception(
          'Failed to create auction package. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      logger.e('❌ POST request failed!');
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
