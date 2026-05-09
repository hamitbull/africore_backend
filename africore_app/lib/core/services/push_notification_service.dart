import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {

  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  // =============================
  // INIT FCM
  // =============================
  static Future<void> initialize() async {

    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    String? token =
    await _messaging.getToken();

    debugPrint("FCM TOKEN: $token");

    // Foreground messages
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {

        debugPrint(
            "Foreground Notification: ${message.notification?.title}");

        _showPopup(message);
      },
    );

    // Background tap
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) {

      debugPrint("Notification clicked");

    });
  }

  // =============================
  // SHOW POPUP IN APP
  // =============================
  static void _showPopup(RemoteMessage message) {

    final context =
        navigatorKey.currentContext;

    if (context == null) return;

    showDialog(

      context: context,

      builder: (_) => AlertDialog(

        title: Text(
          message.notification?.title ?? "",
        ),

        content: Text(
          message.notification?.body ?? "",
        ),

        actions: [

          TextButton(
            onPressed: () =>
                Navigator.pop(context),

            child: const Text("OK"),
          )

        ],
      ),
    );
  }

  // Global navigator key
  static final GlobalKey<NavigatorState>
  navigatorKey =
  GlobalKey<NavigatorState>();
}
