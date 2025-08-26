class OfferModel {
  final String id;
  final String driverName;
  final String vehicleName;
  final String plateNumber;
  final double maxCapacity; // ton
  final double maxVolume;   // m³
  final String vendorLevel;

  OfferModel({
    required this.id,
    required this.driverName,
    required this.vehicleName,
    required this.plateNumber,
    required this.maxCapacity,
    required this.maxVolume,
    required this.vendorLevel,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      driverName: json['driverName'],
      vehicleName: json['vehicleName'],
      plateNumber: json['plateNumber'],
      maxCapacity: (json['maxCapacity'] ?? 0).toDouble(),
      maxVolume: (json['maxVolume'] ?? 0).toDouble(),
      vendorLevel: json['vendorLevel'],
    );
  }
}
