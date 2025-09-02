class User {
  final int id;
  final String name;
  final String company;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.company,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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

  // ✅ Factory untuk object kosong
  factory User.empty() {
    return User(
      id: 0,
      name: 'Unknown User',
      company: '',
      email: '',
      avatar: '',
    );
  }
}
