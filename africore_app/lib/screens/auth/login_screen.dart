import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../core/services/biometric_service.dart';
import '../main/bottom_nav_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final biometricService = BiometricService();
  bool obscurePassword = true;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final auth = context.read<AuthProvider>();
    await auth.login(
      phone: phoneController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted) return;
    if (auth.isLoggedIn) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const BottomNavScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Check your details.")),
      );
    }
  }

  Future<void> biometricLogin() async {
    final available = await biometricService.isBiometricAvailable();
    if (!mounted) return;
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Biometric login is not available.")),
      );
      return;
    }
    final authenticated = await biometricService.authenticate();
    if (!mounted) return;
    if (authenticated) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const BottomNavScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication failed.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 42),
              const Text("Welcome Back 👋",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Login to continue using AFRICORE",
                style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 42),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : login,
                  child: auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(children: [
                  IconButton(
                    icon: const Icon(Icons.fingerprint),
                    iconSize: 64,
                    onPressed: biometricLogin,
                    tooltip: "Login with biometrics",
                  ),
                  const Text("Use fingerprint / device biometrics"),
                ]),
              ),
              TextButton(
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen())),
                child: const Text("Create an AFRICORE account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
