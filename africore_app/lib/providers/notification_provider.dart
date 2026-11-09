import 'package:flutter/foundation.dart';
import '../core/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService service = NotificationService();
  bool isLoading = false;
  List<dynamic> notifications = [];

  Future<void> loadNotifications() async {
    isLoading = true;
    notifyListeners();
    try {
      notifications = await service.getNotifications();
    } catch (error) {
      debugPrint("Notification load failed: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addNotification(Map<String, dynamic> data) {
    notifications.insert(0, data);
    notifyListeners();
  }
}
