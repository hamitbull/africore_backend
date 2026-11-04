import '../config/api_endpoints.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api = ApiService.instance;
  final StorageService _storage = StorageService.instance;

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(ApiEndpoints.register, {
      'name': fullName.trim(),
      'phone': phone.trim(),
      'email': email.trim(),
      'password': password,
    });
    final data = Map<String, dynamic>.from(response.data as Map);
    final token = data['token'] as String?;
    if (token != null && token.isNotEmpty) {
      await _storage.saveToken(token);
    }
    return data;
  }

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await _api.post(ApiEndpoints.login, {
      'phone': phone.trim(),
      'password': password,
    });
    final data = Map<String, dynamic>.from(response.data as Map);
    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw StateError('Server did not return a login token.');
    }
    await _storage.saveToken(token);
    return data;
  }

  Future<void> logout() => _storage.clearToken();

  Future<String?> getToken() => _storage.getToken();

  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _api.get(
      ApiEndpoints.profile,
      authenticated: true,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String email,
  }) async {
    final response = await _api.put(
      ApiEndpoints.profile,
      {'name': fullName.trim(), 'email': email.trim()},
      authenticated: true,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> verifyOTP({
    required String phone,
    required String otp,
  }) async {
    final response = await _api.post('/auth/verify-otp', {
      'phone': phone.trim(),
      'otp': otp.trim(),
    });
    return Map<String, dynamic>.from(response.data as Map);
  }
}
