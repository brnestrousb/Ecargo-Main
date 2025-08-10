import 'package:ecarrgo/core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecarrgo/core/features/auth/domain/entities/user.dart';
import 'package:ecarrgo/core/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> register({
    required String name,
    required String company,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) {
    return remoteDataSource.register(
      name: name,
      company: company,
      email: email,
      password: password,
      phone: phone,
      address: address,
    );
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(
      email: email,
      password: password,
    );
  }
}
