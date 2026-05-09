import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../wallet/wallet_screen.dart';
import '../notifications/notification_screen.dart';
import '../miniapps/miniapp_store_screen.dart';
import '../profile/profile_screen.dart';
import '../kyc/kyc_screen.dart';
import '../main/app_drawer.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final authProvider =
    Provider.of<AuthProvider>(context);

    final user =
    authProvider.user ?? {};

    return Drawer(

      child: Column(

        children: [

          // =============================
          // HEADER
          // =============================
          UserAccountsDrawerHeader(

            currentAccountPicture:
            CircleAvatar(

              backgroundColor:
              Colors.white,

              child: Text(

                user["fullName"] != null

                    ? user["fullName"][0]

                    : "A",

                style: const TextStyle(

                  fontSize: 30,

                  fontWeight:
                  FontWeight.bold,

                  color: Colors.black,
                ),
              ),
            ),

            accountName: Text(
              user["fullName"] ??
                  "AFRICORE User",
            ),

            accountEmail: Text(
              user["email"] ??
                  "No Email",
            ),

            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),

          // =============================
          // MENU ITEMS
          // =============================
          Expanded(

            child: ListView(

              padding: EdgeInsets.zero,

              children: [

                _DrawerItem(

                  icon: Icons.home,

                  title: "Home",

                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
             drawer: const AppDrawer(),
                _DrawerItem(

                  icon:
                  Icons.account_balance_wallet,

                  title: "Wallet",

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                        const WalletScreen(),
                      ),
                    );
                  },
                ),

                _DrawerItem(

                  icon: Icons.apps,

                  title: "Mini Apps",

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                        const MiniAppStoreScreen(),
                      ),
                    );
                  },
                ),

                _DrawerItem(

                  icon: Icons.notifications,

                  title: "Notifications",

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                        const NotificationScreen(),
                      ),
                    );
                  },
                ),

                _DrawerItem(

                  icon: Icons.verified_user,

                  title: "KYC Verification",

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                        const KycScreen(),
                      ),
                    );
                  },
                ),

                _DrawerItem(

                  icon: Icons.person,

                  title: "Profile",

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                        const ProfileScreen(),
                      ),
                    );
                  },
                ),

                const Divider(),

                _DrawerItem(

                  icon: Icons.settings,

                  title: "Settings",

                  onTap: () {},
                ),

                _DrawerItem(

                  icon: Icons.support_agent,

                  title: "Support",

                  onTap: () {},
                ),

                _DrawerItem(

                  icon: Icons.info,

                  title: "About AFRICORE",

                  onTap: () {},
                ),

              ],
            ),
          ),

          // =============================
          // FOOTER
          // =============================
          Container(

            padding: const EdgeInsets.all(20),

            child: const Column(

              children: [

                Divider(),

                SizedBox(height: 10),

                Text(
                  "AFRICORE v1.0.0",
                ),

                SizedBox(height: 5),

                Text(
                  "Powered by AFRICORE OS",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}

// =============================
// DRAWER ITEM
// =============================
class _DrawerItem
    extends StatelessWidget {

  final IconData icon;

  final String title;

  final VoidCallback onTap;

  const _DrawerItem({

    required this.icon,

    required this.title,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(

      leading: Icon(icon),

      title: Text(
        title,
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),

      onTap: onTap,
    );
  }
}
