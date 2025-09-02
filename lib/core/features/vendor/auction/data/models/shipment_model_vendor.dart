import 'user_model.dart';
import 'city_model_vendor.dart';
import 'payment_model_vendor.dart';
import 'status_history_model_vendor.dart';
import 'review_model_vendor.dart';
import 'vendor_model.dart'; // vendor wajib

class Shipment {
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
  final String driverNote;
  final String status;
  final DateTime createdAt;

  final User user;
  final City originCity;
  final City destinationCity;
  final List<Payment> payments;
  final List<StatusHistory> statusHistories;
  final List<Review> reviews;
  final Vendor vendor; // ✅ wajib ada

  Shipment({
    required this.id,
    required this.userId,
    required this.originCityId,
    required this.destinationCityId,
    required this.resiNumber,
    this.itemDetail,
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
    required this.driverNote,
    required this.status,
    required this.createdAt,
    required this.user,
    required this.originCity,
    required this.destinationCity,
    required this.payments,
    required this.statusHistories,
    required this.reviews,
    required this.vendor, // ✅ wajib
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
  return Shipment(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    originCityId: json['origin_city_id'] ?? 0,
    destinationCityId: json['destination_city_id'] ?? 0,
    resiNumber: json['resi_number'] ?? '',
    itemDetail: json['item_detail'],
    itemTypes: json['item_types'] ?? '',
    itemWeightTon: json['item_weight_ton'] ?? '',
    itemValueRp: json['item_value_rp'] ?? '',
    itemVolumeM3: json['item_volume_m3'] ?? '',
    itemDescription: json['item_description'] ?? '',
    pickupAddress: json['pickup_address'] ?? '',
    pickupLatitude: (json['pickup_latitude'] ?? 0).toDouble(),
    pickupLongitude: (json['pickup_longitude'] ?? 0).toDouble(),
    pickupPlaceName: json['pickup_place_name'] ?? '',
    pickupCity: json['pickup_city'] ?? '',
    pickupPostalCode: json['pickup_postal_code'] ?? '',
    pickupCountry: json['pickup_country'] ?? '',
    deliveryAddress: json['delivery_address'] ?? '',
    deliveryLatitude: (json['delivery_latitude'] ?? 0).toDouble(),
    deliveryLongitude: (json['delivery_longitude'] ?? 0).toDouble(),
    deliveryPlaceName: json['delivery_place_name'] ?? '',
    deliveryCity: json['delivery_city'] ?? '',
    deliveryPostalCode: json['delivery_postal_code'] ?? '',
    deliveryCountry: json['delivery_country'] ?? '',
    shippingType: json['shipping_type'] ?? '',
    protection: json['protection'] ?? '',
    driverNote: json['driver_note'] ?? '',
    status: json['status'] ?? '',
    createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),

    // ✅ Null-safe nested parsing
    user: json['user'] != null ? User.fromJson(json['user']) : User.empty(),
    originCity: json['originCity'] != null
        ? City.fromJson(json['originCity'])
        : City.empty(),
    destinationCity: json['destinationCity'] != null
        ? City.fromJson(json['destinationCity'])
        : City.empty(),
    vendor: json['vendor'] != null
        ? Vendor.fromJson(json['vendor'])
        : Vendor.empty(),

    payments: (json['payments'] as List<dynamic>? ?? [])
        .map((e) => Payment.fromJson(e))
        .toList(),
    statusHistories: (json['statusHistories'] as List<dynamic>? ?? [])
        .map((e) => StatusHistory.fromJson(e))
        .toList(),
    reviews: (json['reviews'] as List<dynamic>? ?? [])
        .map((e) => Review.fromJson(e))
        .toList(),
  );
}


  factory Shipment.empty() {
    return Shipment(
        id: 0,
        userId: 0,
        originCityId: 0,
        destinationCityId: 0,
        resiNumber: '',
        itemDetail: null,
        itemTypes: '',
        itemWeightTon: '',
        itemValueRp: '',
        itemVolumeM3: '',
        itemDescription: '',
        pickupAddress: '',
        pickupLatitude: 0.0,
        pickupLongitude: 0.0,
        pickupPlaceName: '',
        pickupCity: '',
        pickupPostalCode: '',
        pickupCountry: '',
        deliveryAddress: '',
        deliveryLatitude: 0.0,
        deliveryLongitude: 0.0,
        deliveryPlaceName: '',
        deliveryCity: '',
        deliveryPostalCode: '',
        deliveryCountry: '',
        shippingType: '',
        protection: '',
        driverNote: '',
        status: '',
        createdAt: DateTime.now(),
        user: User.empty(),
        originCity: City.empty(),
        destinationCity: City.empty(),
        payments: [],
        statusHistories: [],
        reviews: [],
        vendor: Vendor.empty());
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
      'driver_note': driverNote,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'user': user.toJson(),
      'originCity': originCity.toJson(),
      'destinationCity': destinationCity.toJson(),
      'payments': payments.map((e) => e.toJson()).toList(),
      'statusHistories': statusHistories.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'vendor': vendor.toJson(), // ✅ wajib
    };
  }
}
