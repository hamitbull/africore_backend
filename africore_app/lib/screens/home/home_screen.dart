import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/wallet_provider.dart';
import '../kyc/kyc_screen.dart';
import '../miniapps/miniapp_store_screen.dart';
import '../notifications/notification_screen.dart';
import '../wallet/transfer_screen.dart';
import '../wallet/wallet_screen.dart';
import 'app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<WalletProvider>().loadWallet());
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AFRICORE'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: wallet.loadWallet,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF12372A),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your wallet',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    wallet.isLoading
                        ? 'Loading...'
                        : '₦${wallet.balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WalletScreen()),
                    ),
                    child: const Text('Open wallet'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Explore AFRICORE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _HomeAction(
                  title: 'Transfer',
                  icon: Icons.send,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TransferScreen()),
                  ),
                ),
                _HomeAction(
                  title: 'Mini Apps',
                  icon: Icons.apps,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MiniAppStoreScreen()),
                  ),
                ),
                _HomeAction(
                  title: 'Notifications',
                  icon: Icons.notifications_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationScreen()),
                  ),
                ),
                _HomeAction(
                  title: 'Identity',
                  icon: Icons.verified_user_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KycScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color(0xFF087F5B)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
