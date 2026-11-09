import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});
  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final fullNameController = TextEditingController();
  final ninController = TextEditingController();
  final bvnController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? idCardImage;
  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    ninController.dispose();
    bvnController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null && mounted) setState(() => idCardImage = File(picked.path));
  }

  Future<void> submitKyc() async {
    if (fullNameController.text.trim().isEmpty ||
        ninController.text.trim().isEmpty ||
        bvnController.text.trim().isEmpty ||
        idCardImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete all fields and choose your ID image.")),
      );
      return;
    }
    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => isSubmitting = false);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("KYC Submitted"),
        content: const Text("Demo only: your details have not been sent to a verification server."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KYC Verification")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Identity Verification",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Complete your KYC to unlock AFRICORE features."),
            const SizedBox(height: 28),
            TextField(controller: fullNameController,
              decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 16),
            TextField(controller: ninController, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "National ID Number (NIN)", prefixIcon: Icon(Icons.badge))),
            const SizedBox(height: 16),
            TextField(controller: bvnController, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Bank Verification Number (BVN)", prefixIcon: Icon(Icons.account_balance))),
            const SizedBox(height: 24),
            const Text("Upload Government ID", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            InkWell(
              onTap: pickImage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: idCardImage == null
                  ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.upload_file, size: 42),
                      SizedBox(height: 8),
                      Text("Tap to select ID image"),
                    ])
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(idCardImage!, fit: BoxFit.cover),
                    ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : submitKyc,
                child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Submit for review"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
