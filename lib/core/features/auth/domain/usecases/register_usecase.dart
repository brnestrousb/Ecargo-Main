import 'package:ecarrgo/core/features/auth/domain/entities/user.dart';
import 'package:ecarrgo/core/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call({
    required String name,
    required String company,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) {
    return repository.register(
      name: name,
      company: company,
      email: email,
      password: password,
      phone: phone,
      address: address,
    );
  }
}
