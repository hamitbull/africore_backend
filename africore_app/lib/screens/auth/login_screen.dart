import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../../core/services/biometric_service.dart';

import '../main/bottom_nav_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
  phoneController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  final BiometricService
  biometricService =
  BiometricService();

  bool obscurePassword = true;

  // =============================
  // NORMAL LOGIN
  // =============================
  Future<void> login() async {

    final authProvider =
    Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    await authProvider.login(

      phone:
      phoneController.text.trim(),

      password:
      passwordController.text.trim(),

    );

    if (!mounted) return;

    if (authProvider.isLoggedIn) {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const BottomNavScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Invalid credentials"),
        ),
      );
    }
  }

  // =============================
  // BIOMETRIC LOGIN
  // =============================
  Future<void> biometricLogin() async {

    final available =
    await biometricService
        .isBiometricAvailable();

    if (!available) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Biometric not available"),
        ),
      );

      return;
    }

    final authenticated =
    await biometricService.authenticate();

    if (authenticated) {

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const BottomNavScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Authentication failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final authProvider =
    Provider.of<AuthProvider>(context);

    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(24),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 40),

              // =============================
              // APP TITLE
              // =============================
              const Text(

                "Welcome Back 👋",

                style: TextStyle(

                  fontSize: 34,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(

                "Login to continue using AFRICORE",

                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 50),

              // =============================
              // PHONE FIELD
              // =============================
              TextField(

                controller:
                phoneController,

                keyboardType:
                TextInputType.phone,

                decoration:
                InputDecoration(

                  labelText:
                  "Phone Number",

                  prefixIcon:
                  const Icon(
                    Icons.phone,
                  ),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =============================
              // PASSWORD FIELD
              // =============================
              TextField(

                controller:
                passwordController,

                obscureText:
                obscurePassword,

                decoration:
                InputDecoration(

                  labelText:
                  "Password",

                  prefixIcon:
                  const Icon(
                    Icons.lock,
                  ),

                  suffixIcon:
                  IconButton(

                    icon: Icon(

                      obscurePassword

                          ? Icons.visibility

                          : Icons.visibility_off,

                    ),

                    onPressed: () {

                      setState(() {

                        obscurePassword =
                        !obscurePassword;

                      });

                    },
                  ),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // =============================
              // LOGIN BUTTON
              // =============================
              SizedBox(

                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  onPressed:

                  authProvider.isLoading

                      ? null

                      : login,

                  child:

                  authProvider.isLoading

                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )

                      : const Text(

                    "Login",

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // =============================
              // BIOMETRIC LOGIN
              // =============================
              const SizedBox(height: 30),

              Center(

                child: Column(

                  children: [

                    IconButton(

                      iconSize: 65
