import 'package:dio/dio.dart';

import '../config/api_endpoints.dart';
import 'storage_service.dart';

class ApiService {
  ApiService._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: _normalizedBaseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: const {'Content-Type': 'application/json'},
          ),
        );

  static String get _normalizedBaseUrl {
    final value = ApiEndpoints.baseUrl.trim();
    if (value.isEmpty) return '';
    return '${value.replaceFirst(RegExp(r'/+$'), '')}/';
  }

  static final ApiService instance = ApiService._internal();
  final Dio dio;

  void _ensureConfigured() {
    if (ApiEndpoints.baseUrl.trim().isEmpty) {
      throw StateError(
        'API address is not configured. Build with --dart-define=API_BASE_URL=https://your-server/api',
      );
    }
  }

  String _relativePath(String path) =>
      path.startsWith('/') ? path.substring(1) : path;

  Future<Options> authOptions() async {
    final token = await StorageService.instance.getToken();
    if (token == null || token.isEmpty) {
      throw StateError('Please sign in again.');
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<Response<dynamic>> get(
    String path, {
    bool authenticated = false,
  }) async {
    _ensureConfigured();
    return dio.get(
      _relativePath(path),
      options: authenticated ? await authOptions() : null,
    );
  }

  Future<Response<dynamic>> post(
    String path,
    Map<String, dynamic> data, {
    bool authenticated = false,
  }) async {
    _ensureConfigured();
    return dio.post(
      _relativePath(path),
      data: data,
      options: authenticated ? await authOptions() : null,
    );
  }

  Future<Response<dynamic>> put(
    String path,
    Map<String, dynamic> data, {
    bool authenticated = false,
  }) async {
    _ensureConfigured();
    return dio.put(
      _relativePath(path),
      data: data,
      options: authenticated ? await authOptions() : null,
    );
  }
}
