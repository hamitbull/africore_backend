import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'africore_auth_token';

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> getToken() =>
      _storage.read(key: _tokenKey);

  Future<void> clearToken() =>
      _storage.delete(key: _tokenKey);
}
