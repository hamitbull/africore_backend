import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../wallet/wallet_screen.dart';
import '../notifications/notification_screen.dart';
import '../miniapps/miniapp_store_screen.dart';
import '../profile/profile_screen.dart';
import '../kyc/kyc_screen.dart';
import '../performance/virtual_core_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user ?? {};
    final name = (user["fullName"] ?? "AFRICORE User").toString();
    return Drawer(
      child: Column(children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : "A",
              style: const TextStyle(fontSize: 28, color: Colors.black)),
          ),
          accountName: Text(name),
          accountEmail: Text((user["email"] ?? "No Email").toString()),
          decoration: const BoxDecoration(color: Colors.black),
        ),
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: [
            _item(context, Icons.home, "Home", () => Navigator.pop(context)),
            _item(context, Icons.account_balance_wallet, "Wallet", () => _push(context, const WalletScreen())),
            _item(context, Icons.apps, "Mini Apps", () => _push(context, const MiniAppStoreScreen())),
            _item(context, Icons.notifications, "Notifications", () => _push(context, const NotificationScreen())),
            _item(context, Icons.verified_user, "KYC Verification", () => _push(context, const KycScreen())),
            _item(context, Icons.memory, "ASHIRU VIRTUAL CORE X", () => _push(context, const VirtualCoreScreen())),
            _item(context, Icons.person, "Profile", () => _push(context, const ProfileScreen())),
            const Divider(),
            _item(context, Icons.settings, "Settings", () {}),
            _item(context, Icons.support_agent, "Support", () {}),
            _item(context, Icons.info, "About AFRICORE", () {}),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Divider(),
            SizedBox(height: 8),
            Text("AFRICORE v1.0.0"),
            SizedBox(height: 4),
            Text("Powered by AFRICORE OS", style: TextStyle(color: Colors.grey)),
          ]),
        ),
      ]),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _item(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
