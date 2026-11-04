import '../config/api_endpoints.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _api = ApiService.instance;

  Future<List<dynamic>> getNotifications() async {
    final response = await _api.get(
      ApiEndpoints.notifications,
      authenticated: true,
    );
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data['notifications'] is List) {
      return List<dynamic>.from(data['notifications'] as List);
    }
    if (data is Map && data['data'] is List) {
      return List<dynamic>.from(data['data'] as List);
    }
    return <dynamic>[];
  }
}
