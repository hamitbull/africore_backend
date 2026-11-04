import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = 'africore_access_token';

  Future<void> saveToken(String token) async {
    if (token.isEmpty) {
      throw ArgumentError.value(token, 'token', 'Token cannot be empty.');
    }
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);
}
