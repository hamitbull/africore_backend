import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 3),
          () {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const LoginScreen(),
          ),
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: const [

            Icon(
              Icons.public,
              size: 100,
            ),

            SizedBox(height: 20),

            Text(
              "AFRICORE",
              style: TextStyle(
                fontSize: 32,
                fontWeight:
                FontWeight.bold,
              ),
            )

          ],
        ),
      ),
    );
  }
}
