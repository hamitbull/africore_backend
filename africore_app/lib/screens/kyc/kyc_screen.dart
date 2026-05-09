import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() =>
      _KycScreenState();
}

class _KycScreenState
    extends State<KycScreen> {

  final TextEditingController
  fullNameController =
  TextEditingController();

  final TextEditingController
  ninController =
  TextEditingController();

  final TextEditingController
  bvnController =
  TextEditingController();

  File? idCardImage;

  bool isSubmitting = false;

  final ImagePicker picker =
  ImagePicker();

  // =============================
  // PICK ID CARD
  // =============================
  Future<void> pickImage() async {

    final picked =
    await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {

      setState(() {
        idCardImage =
            File(picked.path);
      });

    }
  }

  // =============================
  // SUBMIT KYC
  // =============================
  Future<void> submitKyc() async {

    if (fullNameController.text.isEmpty ||
        ninController.text.isEmpty ||
        bvnController.text.isEmpty ||
        idCardImage == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Complete all fields"),
        ),
      );

      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // =============================
    // SIMULATE API REQUEST
    // =============================
    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      isSubmitting = false;
    });

    if (!mounted) return;

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),

          title: const Text(
            "KYC Submitted",
          ),

          content: const Text(
            "Your verification is under review.",
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("OK"),
            )

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
        const Text("KYC Verification"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 10),

            const Text(

              "Identity Verification",

              style: TextStyle(
                fontSize: 28,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Complete your KYC to unlock all AFRICORE features.",
            ),

            const SizedBox(height: 35),

            // =============================
            // FULL NAME
            // =============================
            TextField(

              controller:
              fullNameController,

              decoration: InputDecoration(

                labelText: "Full Name",

                prefixIcon:
                const Icon(Icons.person),

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
            // NIN
            // =============================
            TextField(

              controller:
              ninController,

              keyboardType:
              TextInputType.number,

              decoration: InputDecoration(

                labelText:
                "National ID Number (NIN)",

                prefixIcon:
                const Icon(
                  Icons.badge,
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
            // BVN
            // =============================
            TextField(

              controller:
              bvnController,

              keyboardType:
              TextInputType.number,

              decoration: InputDecoration(

                labelText:
                "Bank Verification Number (BVN)",

                prefixIcon:
                const Icon(
                  Icons.account_balance,
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

            const SizedBox(height: 30),

            // =============================
            // UPLOAD ID CARD
            // =============================
            const Text(

              "Upload Government ID",

              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(

              onTap: pickImage,

              child: Container(

                height: 180,

                width: double.infinity,

                decoration: BoxDecoration(

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),

                  border: Border.all(
                    color
