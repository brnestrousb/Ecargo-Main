import 'package:ecarrgo/core/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> register({
    required String name,
    required String company,
    required String email,
    required String password,
    required String phone,
    required String address,
  });

  Future<User> login({
    required String email,
    required String password,
  });
}
