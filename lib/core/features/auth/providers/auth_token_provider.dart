// core/providers/auth_token_provider.dart
import 'package:flutter/foundation.dart';
import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';

class AuthTokenProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  final SecureStorageService _storage = SecureStorageService();

  Future<void> loadToken() async {
    _token = await _storage.getToken();
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.saveToken(token);
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.deleteToken();
    notifyListeners();
  }
}
