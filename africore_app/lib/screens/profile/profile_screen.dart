import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authProvider =
    Provider.of<AuthProvider>(context);

    final user =
    authProvider.user ?? {};

    return Scaffold(

      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          // =============================
          // PROFILE HEADER
          // =============================
          Center(

            child: Column(

              children: [

                CircleAvatar(

                  radius: 50,

                  backgroundColor:
                  Colors.black,

                  child: Text(

                    user["fullName"] != null

                        ? user["fullName"][0]
                        : "A",

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 35,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(

                  user["fullName"] ??
                      "AFRICORE User",

                  style: const TextStyle(

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  user["email"] ??
                      "No email",
                ),

                const SizedBox(height: 5),

                Text(
                  user["phone"] ??
                      "No phone",
                ),

              ],
            ),
          ),

          const SizedBox(height: 35),

          // =============================
          // ACCOUNT SECTION
          // =============================
          const Text(

            "Account",

            style: TextStyle(

              fontSize: 20,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _ProfileTile(

            icon: Icons.person,

            title: "Edit Profile",

            subtitle:
            "Update account details",

            onTap: () {},

          ),

          _ProfileTile(

            icon: Icons.lock,

            title: "Security",

            subtitle:
            "Password & biometrics",

            onTap: () {},

          ),

          _ProfileTile(

            icon: Icons.verified_user,

            title: "KYC Verification",

            subtitle:
            "Verify your identity",

            onTap: () {},

          ),

          const SizedBox(height: 30),

          // =============================
          // SETTINGS
          // =============================
          const Text(

            "Settings",

            style: TextStyle(

              fontSize: 20,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _ProfileTile(

            icon: Icons.notifications,

            title: "Notifications",

            subtitle:
            "Manage alerts",

            onTap: () {},

          ),

          _ProfileTile(

            icon: Icons.dark_mode,

            title: "Dark Mode",

            subtitle:
            "Switch app appearance",

            onTap: () {},

          ),

          _ProfileTile(

            icon: Icons.language,

            title: "Language",

            subtitle:
            "Change app language",

            onTap: () {},

          ),

          const SizedBox(height: 30),

          // =============================
          // SUPPORT
          // =============================
          const Text(

            "Support",

            style: TextStyle(

              fontSize: 20,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _ProfileTile(

            icon: Icons.help,

            title: "Help Center",

            subtitle:
            "FAQs & support",

            onTap: () {},

          ),

          _ProfileTile(

            icon: Icons.info,

            title: "About AFRICORE",

            subtitle:
            "Platform information",

            onTap: () {},

          ),

          const SizedBox(height: 40),

          // =============================
          // LOGOUT BUTTON
          // =============================
          SizedBox(

            height: 55,

            child: ElevatedButton.icon(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.red,

                foregroundColor:
                Colors.white,

              ),

              onPressed: () async {

                await authProvider.logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                    const LoginScreen(),
                  ),

                      (route) => false,
                );
              },

              icon: const Icon(Icons.logout),

              label: const Text(

                "Logout",

                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

        ],
      ),
    );
  }
}

// =============================
// PROFILE TILE
// =============================
class _ProfileTile
    extends StatelessWidget {

  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const _ProfileTile({

    required this.icon,

    required this.title,

    required this.subtitle,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 15,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 10,

            offset:
            const Offset(0, 4),
          )

        ],
      ),

      child: ListTile(

        onTap: onTap,

        leading: Container(

          padding:
          const EdgeInsets.all(10),

          decoration: BoxDecoration(

            color: Colors.black,

            borderRadius:
            BorderRadius.circular(12),

          ),

          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),

        title: Text(

          title,

          style: const TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),

        subtitle: Text(subtitle),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
      ),
    );
  }
}
