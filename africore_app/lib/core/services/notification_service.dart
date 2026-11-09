import 'package:dio/dio.dart';
import 'storage_service.dart';

class NotificationService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://yourdomain.com/api",
    headers: const {"Content-Type": "application/json"},
  ));
  final StorageService _storage = StorageService();

  Future<List<dynamic>> getNotifications() async {
    final token = await _storage.getToken();
    final response = await _dio.get(
      "/notifications",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data["notifications"] is List) {
      return data["notifications"] as List<dynamic>;
    }
    return <dynamic>[];
  }
}
