import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Do not print device push tokens to CI or device logs.
    await _messaging.getToken();

    FirebaseMessaging.onMessage.listen(_showPopup);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('AFRICORE notification opened');
    });
  }

  static void _showPopup(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message.notification?.title ?? 'AFRICORE'),
        content: Text(message.notification?.body ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
