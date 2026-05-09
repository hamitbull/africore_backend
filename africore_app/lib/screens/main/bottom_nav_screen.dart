import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../wallet/wallet_screen.dart';
import '../miniapps/miniapp_store_screen.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() =>
      _BottomNavScreenState();
}

class _BottomNavScreenState
    extends State<BottomNavScreen> {

  int currentIndex = 0;

  final List<Widget> pages = [

    const HomeScreen(),
    const WalletScreen(),
    const MiniAppStoreScreen(),
    const NotificationScreen(),
    const ProfileScreen(),

  ];

  // =============================
  // CHANGE TAB
  // =============================
  void onTabChanged(int index) {

    setState(() {
      currentIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: onTabChanged,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.black,

        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Wallet",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: "Mini Apps",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

        ],
      ),
    );
  }
}
