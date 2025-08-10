class User {
  final int id;
  final String email;
  final String name;
  final String company;
  final String avatar;
  final int roleId;
  final bool isVerified;
  final String accessToken;
  final String tokenType;
  final String expiresIn;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.company,
    required this.avatar,
    required this.roleId,
    required this.isVerified,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });
}
