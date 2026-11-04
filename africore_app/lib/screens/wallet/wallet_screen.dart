import 'package:flutter/material.dart';

import '../../core/services/wallet_service.dart';
import 'transaction_history_screen.dart';
import 'transfer_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService walletService = WalletService();

  bool isLoading = true;
  double balance = 0;
  String accountNumber = '';
  String bankName = '';
  List<dynamic> transactions = [];

  Future<void> loadWallet() async {
    try {
      final data = await walletService.getWallet();
      final wallet = data['wallet'] is Map ? data['wallet'] as Map : {};
      final user = data['user'] is Map ? data['user'] as Map : {};
      final virtualAccount = user['virtualAccount'] is Map
          ? user['virtualAccount'] as Map
          : {};

      if (!mounted) return;
      setState(() {
        balance = (wallet['balance'] as num?)?.toDouble() ?? 0;
        accountNumber = virtualAccount['accountNumber']?.toString() ?? '';
        bankName = virtualAccount['bankName']?.toString() ?? '';
        transactions = data['transactions'] is List
            ? List<dynamic>.from(data['transactions'] as List)
            : <dynamic>[];
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load wallet: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadWallet,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12372A),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available balance',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '₦${balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(color: Colors.white24, height: 32),
                        const Text(
                          'Virtual account',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          accountNumber.isEmpty ? 'Not available yet' : accountNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (bankName.isNotEmpty)
                          Text(bankName, style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.send,
                          label: 'Transfer',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TransferScreen(),
                              ),
                            );
                            if (mounted) loadWallet();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.add_card,
                          label: 'Fund wallet',
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Wallet funding is not enabled until the payment provider is configured.',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.history,
                          label: 'History',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TransactionHistoryScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Recent transactions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (transactions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No transactions yet', textAlign: TextAlign.center),
                    ),
                  ...transactions.map((item) {
                    final tx = item is Map ? item : <dynamic, dynamic>{};
                    final isCredit = tx['type'] == 'credit';
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                          ),
                        ),
                        title: Text(tx['description']?.toString() ?? 'Transaction'),
                        subtitle: Text(tx['createdAt']?.toString() ?? ''),
                        trailing: Text(
                          '${isCredit ? '+' : '-'}₦${tx['amount'] ?? 0}',
                          style: TextStyle(
                            color: isCredit ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF12372A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
