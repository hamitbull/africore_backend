import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/push_notification_service.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_service.dart';
import 'providers/wallet_provider.dart';
import 'screens/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Messaging is optional at runtime on devices without Google services.
  try {
    await Firebase.initializeApp();
    await PushNotificationService.initialize();
  } catch (error) {
    debugPrint('Firebase notifications unavailable: $error');
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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087F5B)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F9F8),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF14231D),
            centerTitle: true,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF087F5B),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
