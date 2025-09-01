class City {
  final int id;
  final String name;
  final String? province;
  final bool isActive;

  City({
    required this.id,
    required this.name,
    this.province,
    required this.isActive,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] ?? '',
      province: json['province'],
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'province': province,
      'is_active': isActive,
    };
  }
}
