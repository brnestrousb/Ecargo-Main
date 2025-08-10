class LocationData {
  final String address;
  final double latitude;
  final double longitude;

  final String? placeName; // e.g. "Rumah Pribadi" / "Alfamart Ciledug"
  final String? detail; // e.g. "Blok A12, samping masjid"
  final String? city;
  final String? postalCode;
  final String? country;

  LocationData({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.placeName,
    this.detail,
    this.city,
    this.postalCode,
    this.country,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        if (placeName != null) 'placeName': placeName,
        if (detail != null) 'detail': detail,
        if (city != null) 'city': city,
        if (postalCode != null) 'postalCode': postalCode,
        if (country != null) 'country': country,
      };
}
