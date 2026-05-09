import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/notification_provider.dart';

import 'core/services/push_notification_service.dart';

import 'screens/main/bottom_nav_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // =============================
  // FIREBASE INIT
  // =============================
  await Firebase.initializeApp();

  // =============================
  // PUSH NOTIFICATION INIT
  // =============================
  await PushNotificationService.initialize();

  runApp(const AfricoreApp());
}

class AfricoreApp extends StatelessWidget {
  const AfricoreApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        // =============================
        // AUTH PROVIDER
        // =============================
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        // =============================
        // WALLET PROVIDER
        // =============================
        ChangeNotifierProvider(
          create: (_) => WalletProvider(),
        ),

        // =============================
        // NOTIFICATION PROVIDER
        // =============================
        ChangeNotifierProvider(
          create: (_) =>
              NotificationProvider(),
        ),

      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: "AFRICORE",

        navigatorKey:
        PushNotificationService
            .navigatorKey,

        theme: ThemeData(

          primarySwatch: Colors.blue,

          scaffoldBackgroundColor:
          Colors.white,

          appBarTheme: const AppBarTheme(

            elevation: 0,

            backgroundColor:
            Colors.white,

            foregroundColor:
            Colors.black,

            centerTitle: true,

          ),

          inputDecorationTheme:
          InputDecorationTheme(

            border: OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(15),

            ),

            focusedBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(15),

              borderSide:
              const BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),

          elevatedButtonTheme:
          ElevatedButtonThemeData(

            style:
            ElevatedButton.styleFrom(

              backgroundColor:
              Colors.black,

              foregroundColor:
              Colors.white,

              shape:
              RoundedRectangleBorder(

                borderRadius:
                BorderRadius.circular(
                  15,
                ),
              ),

              minimumSize:
              const Size(
                double.infinity,
                55,
              ),
            ),
          ),
        ),

        // =============================
        // HOME SCREEN
        // =============================
        home: const BottomNavScreen(),

      ),
    );
  }
}
