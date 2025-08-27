import 'package:ecarrgo/core/features/customer/activity/data/models/city_model.dart';
import 'package:logger/logger.dart';

class ShipmentModel {
  // fields sesuai JSON shipment
  final int id;
  final int userId;
  final int originCityId;
  final int destinationCityId;
  final String resiNumber;
  final String? itemDetail;
  final String itemTypes;
  final String itemWeightTon;
  final String itemValueRp;
  final String itemVolumeM3;
  final String itemDescription;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupPlaceName;
  final String pickupCity;
  final String pickupPostalCode;
  final String pickupCountry;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String deliveryPlaceName;
  final String deliveryCity;
  final String deliveryPostalCode;
  final String deliveryCountry;
  final String shippingType;
  final String protection;
  final DateTime deliveryDatetime;
  final String driverNote;
  final String status;
  final DateTime? startDatetime;
  final DateTime? endDatetime;
  final double? weightKg;
  final double? volumeM3;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final CityModel originCity;
  final CityModel destinationCity;

  ShipmentModel(
      {
      // constructor fields
      required this.id,
      required this.userId,
      required this.originCityId,
      required this.destinationCityId,
      required this.resiNumber,
      required this.itemDetail,
      required this.itemTypes,
      required this.itemWeightTon,
      required this.itemValueRp,
      required this.itemVolumeM3,
      required this.itemDescription,
      required this.pickupAddress,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.pickupPlaceName,
      required this.pickupCity,
      required this.pickupPostalCode,
      required this.pickupCountry,
      required this.deliveryAddress,
      required this.deliveryLatitude,
      required this.deliveryLongitude,
      required this.deliveryPlaceName,
      required this.deliveryCity,
      required this.deliveryPostalCode,
      required this.deliveryCountry,
      required this.shippingType,
      required this.protection,
      required this.deliveryDatetime,
      required this.driverNote,
      required this.status,
      required this.startDatetime,
      required this.endDatetime,
      required this.weightKg,
      required this.volumeM3,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      required this.originCity,
      required this.destinationCity});

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseNullableDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return ShipmentModel(
      id: json['id'],
      userId: json['user_id'],
      originCityId: json['origin_city_id'],
      destinationCityId: json['destination_city_id'],
      resiNumber: json['resi_number'],
      itemDetail: json['item_detail'],
      itemTypes: json['item_types'],
      itemWeightTon: json['item_weight_ton'],
      itemValueRp: json['item_value_rp'],
      itemVolumeM3: json['item_volume_m3'],
      itemDescription: json['item_description'],
      pickupAddress: json['pickup_address'],
      pickupLatitude: (json['pickup_latitude'] as num).toDouble(),
      pickupLongitude: (json['pickup_longitude'] as num).toDouble(),
      pickupPlaceName: json['pickup_place_name'],
      pickupCity: json['pickup_city'],
      pickupPostalCode: json['pickup_postal_code'],
      pickupCountry: json['pickup_country'],
      deliveryAddress: json['delivery_address'],
      deliveryLatitude: (json['delivery_latitude'] as num).toDouble(),
      deliveryLongitude: (json['delivery_longitude'] as num).toDouble(),
      deliveryPlaceName: json['delivery_place_name'],
      deliveryCity: json['delivery_city'],
      deliveryPostalCode: json['delivery_postal_code'],
      deliveryCountry: json['delivery_country'],
      shippingType: json['shipping_type'],
      protection: json['protection'],
      deliveryDatetime:
          parseNullableDateTime(json['delivery_datetime']) ?? DateTime.now(),
      driverNote: json['driver_note'],
      status: json['status'],
      startDatetime: parseNullableDateTime(json['start_datetime']),
      endDatetime: parseNullableDateTime(json['end_datetime']),
      weightKg: json['weight_kg'] != null
          ? (json['weight_kg'] as num).toDouble()
          : null,
      volumeM3: json['volume_m3'] != null
          ? (json['volume_m3'] as num).toDouble()
          : null,
      createdAt: parseNullableDateTime(json['created_at']) ?? DateTime.now(),
      updatedAt: parseNullableDateTime(json['updated_at']) ?? DateTime.now(),
      deletedAt: parseNullableDateTime(json['deleted_at']),
      originCity: CityModel.fromJson(json['originCity']),
      destinationCity: CityModel.fromJson(json['destinationCity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'origin_city_id': originCityId,
      'destination_city_id': destinationCityId,
      'resi_number': resiNumber,
      'item_detail': itemDetail,
      'item_types': itemTypes,
      'item_weight_ton': itemWeightTon,
      'item_value_rp': itemValueRp,
      'item_volume_m3': itemVolumeM3,
      'item_description': itemDescription,
      'pickup_address': pickupAddress,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'pickup_place_name': pickupPlaceName,
      'pickup_city': pickupCity,
      'pickup_postal_code': pickupPostalCode,
      'pickup_country': pickupCountry,
      'delivery_address': deliveryAddress,
      'delivery_latitude': deliveryLatitude,
      'delivery_longitude': deliveryLongitude,
      'delivery_place_name': deliveryPlaceName,
      'delivery_city': deliveryCity,
      'delivery_postal_code': deliveryPostalCode,
      'delivery_country': deliveryCountry,
      'shipping_type': shippingType,
      'protection': protection,
      'delivery_datetime': deliveryDatetime.toIso8601String(),
      'driver_note': driverNote,
      'status': status,
      'start_datetime': startDatetime?.toIso8601String(),
      'end_datetime': endDatetime?.toIso8601String(),
      'weight_kg': weightKg,
      'volume_m3': volumeM3,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  ShipmentModel toEntity() {
    return ShipmentModel(
      id: id,
      userId: userId,
      originCityId: originCityId,
      destinationCityId: destinationCityId,
      resiNumber: resiNumber,
      itemDetail: itemDetail,
      itemTypes: itemTypes,
      itemWeightTon: itemWeightTon,
      itemValueRp: itemValueRp,
      itemVolumeM3: itemVolumeM3,
      itemDescription: itemDescription,
      pickupAddress: pickupAddress,
      pickupLatitude: pickupLatitude,
      pickupLongitude: pickupLongitude,
      pickupPlaceName: pickupPlaceName,
      pickupCity: pickupCity,
      pickupPostalCode: pickupPostalCode,
      pickupCountry: pickupCountry,
      deliveryAddress: deliveryAddress,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      deliveryPlaceName: deliveryPlaceName,
      deliveryCity: deliveryCity,
      deliveryPostalCode: deliveryPostalCode,
      deliveryCountry: deliveryCountry,
      shippingType: shippingType,
      protection: protection,
      deliveryDatetime: deliveryDatetime,
      driverNote: driverNote,
      status: status,
      startDatetime: startDatetime,
      endDatetime: endDatetime,
      weightKg: weightKg,
      volumeM3: volumeM3,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      originCity: originCity.toEntity(),
      destinationCity: destinationCity.toEntity(),
    );
  }
}

Map<String, dynamic> parseShipmentFromResponse(Map<String, dynamic> response) {
  final shipmentJson = response['data']?['shipment'];
  Logger().i('Shipment data raw: $shipmentJson');
  if (shipmentJson == null) {
    throw Exception('❌ Shipment data not found in response.');
  }
  return shipmentJson as Map<String, dynamic>;
}
