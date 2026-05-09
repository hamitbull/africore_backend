import 'package:flutter/material.dart';

import '../../core/services/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() =>
      _WalletScreenState();
}

class _WalletScreenState
    extends State<WalletScreen> {

  final WalletService walletService =
      WalletService();

  bool isLoading = true;

  double balance = 0;

  String accountNumber = "";

  String bankName = "";

  List transactions = [];

  // =============================
  // LOAD WALLET DATA
  // =============================
  Future<void> loadWallet() async {

    try {

      final data =
      await walletService.getWallet();

      setState(() {

        balance =
            data["wallet"]["balance"]
            .toDouble();

        accountNumber =
        data["user"]["virtualAccount"]
        ["accountNumber"] ?? "";

        bankName =
        data["user"]["virtualAccount"]
        ["bankName"] ?? "";

        transactions =
            data["transactions"] ?? [];

      });

    } catch (e) {

      debugPrint(e.toString());

    } finally {

      setState(() {
        isLoading = false;
      });

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

      appBar: AppBar(
        title: const Text("Wallet"),
      ),

      body: isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : RefreshIndicator(

        onRefresh: loadWallet,

        child: ListView(
          padding:
          const EdgeInsets.all(20),

          children: [

            // =============================
            // BALANCE CARD
            // =============================
            Container(

              padding:
              const EdgeInsets.all(25),

              decoration: BoxDecoration(

                color: Colors.black,

                borderRadius:
                BorderRadius.circular(25),

              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Available Balance",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₦${balance.toStringAsFixed(2)}",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(
                    color: Colors.white24,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Virtual Account",

                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    accountNumber,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    bankName,

                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 30),

            // =============================
            // QUICK ACTIONS
            // =============================
            Row(

              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                _ActionButton(
                  icon: Icons.send,
                  label: "Transfer",
                  onTap: () {},
                ),

                _ActionButton(
                  icon: Icons.download,
                  label: "Fund",
                  onTap: () {},
                ),

                _ActionButton(
                  icon: Icons.history,
                  label: "History",
                  onTap: () {},
                ),

              ],
            ),

            const SizedBox(height: 40),

            // =============================
            // TRANSACTIONS
            // =============================
            const Text(
              "Recent Transactions",

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (transactions.isEmpty)

              const Center(
                child:
                Text("No transactions yet"),
              ),

            ...transactions.map((tx) {

              return Card(

                elevation: 1,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),

                child: ListTile(

                  leading: CircleAvatar(

                    child: Icon(

                      tx["type"] == "credit"

                          ? Icons.arrow_downward

                          : Icons.arrow_upward,

                    ),

                  ),

                  title: Text(
                    tx["description"] ?? "",
                  ),

                  subtitle: Text(
                    tx["createdAt"] ?? "",
                  ),

                  trailing: Text(

                    "₦${tx["amount"]}",

                    style: TextStyle(

                      color:
                      tx["type"] == "credit"

                          ? Colors.green

                          : Colors.red,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              );

            }).toList()

          ],
        ),
      ),
    );
  }
}

// =============================
// ACTION BUTTON
// =============================
class _ActionButton extends StatelessWidget {

  final IconData icon;

  final String label;

  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Column(

        children: [

          Container(

            padding:
            const EdgeInsets.all(18),

            decoration: BoxDecoration(

              color: Colors.black,

              borderRadius:
              BorderRadius.circular(18),

            ),

            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(label)

        ],
      ),
    );
  }
}
