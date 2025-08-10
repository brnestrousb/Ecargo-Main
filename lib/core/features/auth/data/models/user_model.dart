import 'package:ecarrgo/core/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.company,
    required super.avatar,
    required super.roleId,
    required super.isVerified,
    required super.accessToken,
    required super.tokenType,
    required super.expiresIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final user = data['user'];

    return UserModel(
      id: user['id'],
      email: user['email'],
      name: user['name'],
      company: user['company'],
      avatar: user['avatar'],
      roleId: user['role_id'],
      isVerified: user['is_verified'],
      accessToken: data['access_token'],
      tokenType: data['token_type'],
      expiresIn: data['expires_in'],
    );
  }
}
