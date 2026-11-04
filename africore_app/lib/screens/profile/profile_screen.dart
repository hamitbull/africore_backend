import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user ?? <String, dynamic>{};
    final name = (user['name'] ?? user['fullName'] ?? 'AFRICORE User').toString();
    final email = (user['email'] ?? 'No email').toString();
    final phone = (user['phone'] ?? 'No phone number').toString();
    final afroId = (user['afro_id'] ?? 'Not assigned').toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 42,
            backgroundColor: const Color(0xFF12372A),
            child: Text(
              name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'A',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(email, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          _ProfileInfoTile(icon: Icons.phone_outlined, title: 'Phone', value: phone),
          _ProfileInfoTile(icon: Icons.alternate_email, title: 'AFRICORE ID', value: afroId),
          _ProfileInfoTile(
            icon: Icons.verified_user_outlined,
            title: 'KYC status',
            value: (user['kycStatus'] ?? 'unverified').toString(),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: auth.isLoading
                ? null
                : () async {
                    await auth.logout();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
