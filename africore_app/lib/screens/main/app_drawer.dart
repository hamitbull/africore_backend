import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../kyc/kyc_screen.dart';
import '../miniapps/miniapp_store_screen.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../wallet/wallet_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user ?? <String, dynamic>{};
    final fullName = user['name'] ?? user['fullName'] ?? 'AFRICORE User';
    final email = user['email'] ?? 'No email';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                fullName.toString().isNotEmpty
                    ? fullName.toString().substring(0, 1).toUpperCase()
                    : 'A',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF087F5B),
                ),
              ),
            ),
            accountName: Text(fullName.toString()),
            accountEmail: Text(email.toString()),
            decoration: const BoxDecoration(color: Color(0xFF087F5B)),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _item(context, Icons.home_outlined, 'Home'),
                _item(context, Icons.account_balance_wallet_outlined, 'Wallet',
                    const WalletScreen()),
                _item(context, Icons.apps_outlined, 'Mini Apps',
                    const MiniAppStoreScreen()),
                _item(context, Icons.notifications_outlined, 'Notifications',
                    const NotificationScreen()),
                _item(context, Icons.verified_user_outlined, 'KYC',
                    const KycScreen()),
                _item(context, Icons.person_outline, 'Profile',
                    const ProfileScreen()),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('AFRICORE OS • v1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title, [
    Widget? destination,
  ]) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        }
      },
    );
  }
}
