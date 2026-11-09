import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/notification_provider.dart';
import 'core/services/push_notification_service.dart';
import 'screens/main/bottom_nav_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase is optional for the core app shell. A missing or invalid
  // google-services configuration must never leave the user on a white screen.
  var firebaseReady = false;
  try {
    await Firebase.initializeApp();
    firebaseReady = true;
    debugPrint('AFRICORE: Firebase initialized');
  } catch (error, stackTrace) {
    debugPrint('AFRICORE: Firebase unavailable: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  if (firebaseReady) {
    try {
      await PushNotificationService.initialize();
    } catch (error, stackTrace) {
      debugPrint('AFRICORE: Push notifications disabled: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  runApp(const AfricoreApp());
}

class AfricoreApp extends StatelessWidget {
  const AfricoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AFRICORE',
        navigatorKey: PushNotificationService.navigatorKey,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00BFA6),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F8FA),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF071321),
            centerTitle: false,
          ),
        ),
        home: const BottomNavScreen(),
      ),
    );
  }
}
