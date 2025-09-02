class Vendor {
  final int id;
  final String name;
  final String company;
  final String email;
  final String avatar;

  Vendor({
    required this.id,
    required this.name,
    required this.company,
    required this.email,
    required this.avatar,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'email': email,
      'avatar': avatar,
    };
  }

  factory Vendor.empty() {
    return Vendor(
      id: 0,
      name: 'Unknown Vendor',
      company: '',
      email: '',
      avatar: '',
    );
  }
}
