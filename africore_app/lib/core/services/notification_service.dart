import 'package:flutter/material.dart';

import '../core/services/notification_service.dart';

class NotificationProvider
    extends ChangeNotifier {

  final NotificationService service =
  NotificationService();

  bool isLoading = false;

  List notifications = [];

  // =============================
  // LOAD NOTIFICATIONS
  // =============================
  Future<void> loadNotifications() async {

    isLoading = true;
    notifyListeners();

    try {

      final data =
      await service.getNotifications();

      notifications = data;

    } catch (e) {

      debugPrint(e.toString());

    }

    isLoading = false;
    notifyListeners();
  }

  // =============================
  // ADD REAL-TIME NOTIFICATION
  // =============================
  void addNotification(Map data) {

    notifications.insert(0, data);

    notifyListeners();
  }
}
