import 'package:flutter/material.dart';

class KycScreen extends StatelessWidget {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identity verification')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Icon(Icons.verified_user_outlined, size: 64, color: Color(0xFF087F5B)),
          SizedBox(height: 20),
          Text(
            'Verify your identity securely',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Identity verification is not yet connected to the live verification provider. '
            'For your protection, do not enter your BVN, NIN or upload identity documents '
            'until the secure KYC API and approved verification provider are configured.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
