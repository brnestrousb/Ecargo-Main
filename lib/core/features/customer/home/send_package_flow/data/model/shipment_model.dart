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
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
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
      driverNote: json['driver_note'],
      status: json['status'],
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
      'driver_note': driverNote,
      'status': status,
    };
  }
}
