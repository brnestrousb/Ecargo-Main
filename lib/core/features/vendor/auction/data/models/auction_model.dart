class AuctionDetail {
  final String customerName;
  final String modelDelivery;
  final double minBid;
  final String deliveryType;
  final String distance;
  final String weight;
  final String category;
  final String pickupAddress;
  final String destinationAddress;
  final String note;
  final DateTime deliveryDate;
  final String deliveryTime;
  final double itemWeight;
  final double itemValue;
  final double itemDimension;
  final String itemDescription;
  final String shippingType;
  final String shippingDesc;
  final String shippingEstimate;
  final double shippingPrice;
  final String protectionType;
  final double protectionPrice;
  final String protectionDesc;
  final int totalBids;
  final String remainingTime;
  final String detailPickupAddress;
  final String detailDestinationAddress;

  // Tambahan field koordinat
  final double pickupLat;
  final double pickupLng;
  final double destinationLat;
  final double destinationLng;
  final double userLat;
  final double userLng;

  AuctionDetail({
    required this.customerName,
    required this.modelDelivery,
    required this.minBid,
    required this.deliveryType,
    required this.distance,
    required this.weight,
    required this.category,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.note,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.itemWeight,
    required this.itemValue,
    required this.itemDimension,
    required this.itemDescription,
    required this.shippingType,
    required this.shippingDesc,
    required this.shippingEstimate,
    required this.shippingPrice,
    required this.protectionType,
    required this.protectionPrice,
    required this.protectionDesc,
    required this.totalBids,
    required this.remainingTime,
    required this.detailPickupAddress,
    required this.detailDestinationAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.userLat,
    required this.userLng,
  });

  factory AuctionDetail.fromJson(Map<String, dynamic> json) {
    return AuctionDetail(
      customerName: json['customerName'],
      modelDelivery: json['modelDelivery'],
      minBid: (json['minBid'] ?? 0).toDouble(),
      deliveryType: json['deliveryType'],
      distance: json['distance'],
      weight: json['weight'],
      category: json['category'],
      pickupAddress: json['pickupAddress'],
      destinationAddress: json['destinationAddress'],
      note: json['note'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      deliveryTime: json['deliveryTime'],
      itemWeight: (json['itemWeight'] ?? 0).toDouble(),
      itemValue: (json['itemValue'] ?? 0).toDouble(),
      itemDimension: (json['itemDimension'] ?? 0).toDouble(),
      itemDescription: json['itemDescription'],
      shippingType: json['shippingType'],
      shippingDesc: json['shippingDesc'],
      shippingEstimate: json['shippingEstimate'],
      shippingPrice: (json['shippingPrice'] ?? 0).toDouble(),
      protectionType: json['protectionType'],
      protectionPrice: (json['protectionPrice'] ?? 0).toDouble(),
      protectionDesc: json['protectionDesc'],
      totalBids: json['totalBids'],
      remainingTime: json['remainingTime'],
      detailPickupAddress: json['detailPickupAddress'],
      detailDestinationAddress: json['detailDestinationAddress'],

      // mapping koordinat
      pickupLat: (json['pickupLat'] ?? 0).toDouble(),
      pickupLng: (json['pickupLng'] ?? 0).toDouble(),
      destinationLat: (json['destinationLat'] ?? 0).toDouble(),
      destinationLng: (json['destinationLng'] ?? 0).toDouble(),
      userLat: (json['userLat'] ?? 0).toDouble(),
      userLng: (json['userLng'] ?? 0).toDouble(),
    );
  }
}
