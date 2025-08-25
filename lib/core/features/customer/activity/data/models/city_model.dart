class CityModel {
  final int id;
  final String name;
  final String? province;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CityModel({
    required this.id,
    required this.name,
    this.province,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      province: json['province'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  CityModel toEntity() {
    return CityModel(
      id: id,
      name: name,
      province: province,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}  
