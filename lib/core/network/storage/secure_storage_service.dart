// lib/core/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async =>
      _storage.write(key: 'access_token', value: token);

  Future<String?> getToken() async => _storage.read(key: 'access_token');

  Future<void> deleteToken() async => _storage.delete(key: 'access_token');
}
