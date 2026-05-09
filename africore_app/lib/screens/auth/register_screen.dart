import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';

import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final ApiService apiService = ApiService();

  final TextEditingController fullNameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;

  // =============================
  // REGISTER USER
  // =============================
  Future<void> register() async {

    setState(() {
      isLoading = true;
    });

    try {

      final response = await apiService.post(
        "/auth/register",
        {
          "fullName":
          fullNameController.text.trim(),

          "phone":
          phoneController.text.trim(),

          "email":
          emailController.text.trim(),

          "password":
          passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
            Text("Registration successful"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const HomeScreen(),
          ),
        );

      }

    } catch (error) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text("Registration failed"),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Account"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 20),

            const Text(
              "Create AFRICORE Account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Join the future African ecosystem",
            ),

            const SizedBox(height: 40),

            // =============================
            // FULL NAME
            // =============================
            TextField(
              controller: fullNameController,

              decoration: InputDecoration(
                labelText: "Full Name",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =============================
            // PHONE
            // =============================
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,

              decoration: InputDecoration(
                labelText: "Phone Number",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =============================
            // EMAIL
            // =============================
            TextField(
              controller: emailController,
              keyboardType:
              TextInputType.emailAddress,

              decoration: InputDecoration(
                labelText: "Email Address",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =============================
            // PASSWORD
            // =============================
            TextField(
              controller: passwordController,
              obscureText: true,

              decoration: InputDecoration(
                labelText: "Password",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =============================
            // REGISTER BUTTON
            // =============================
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                onPressed:
                isLoading ? null : register,

                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                child: isLoading

                    ? const CircularProgressIndicator()

                    : const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =============================
            // LOGIN LINK
            // =============================
            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                const Text(
                  "Already have an account?",
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text("Login"),
                )

              ],
            )

          ],
        ),
      ),
    );
  }
}
