import 'package:flutter/material.dart';

import '../../core/services/wallet_service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() =>
      _TransferScreenState();
}

class _TransferScreenState
    extends State<TransferScreen> {

  final WalletService walletService =
      WalletService();

  final TextEditingController afroIdController =
      TextEditingController();

  final TextEditingController amountController =
      TextEditingController();

  final TextEditingController noteController =
      TextEditingController();

  bool isLoading = false;

  // =============================
  // SEND TRANSFER
  // =============================
  Future<void> sendTransfer() async {

    final receiverAfroId =
    afroIdController.text.trim();

    final amount =
    double.tryParse(
      amountController.text.trim(),
    );

    if (receiverAfroId.isEmpty ||
        amount == null ||
        amount <= 0) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Enter valid details"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final response =
      await walletService.transfer(
        receiverAfroId: receiverAfroId,
        amount: amount,
      );

      if (!mounted) return;

      showDialog(

        context: context,

        builder: (_) {

          return AlertDialog(

            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20),
            ),

            title: const Text(
              "Transfer Successful",
            ),

            content: Column(
              mainAxisSize:
              MainAxisSize.min,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  "Amount: ₦$amount",
                ),

                const SizedBox(height: 10),

                Text(
                  "Receiver: $receiverAfroId",
                ),

                const SizedBox(height: 10),

                Text(
                  response["message"] ??
                      "Transfer completed",
                ),

              ],
            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context);
                  Navigator.pop(context);

                },

                child: const Text("OK"),
              )

            ],
          );
        },
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Transfer Money"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 10),

            const Text(
              "Send Money",

              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Transfer instantly to another AFRICORE user",
            ),

            const SizedBox(height: 40),

            // =============================
            // RECEIVER AFRO ID
            // =============================
            TextField(

              controller: afroIdController,

              decoration: InputDecoration(

                labelText: "Receiver Afro ID",

                hintText: "AFRO123456",

                prefixIcon:
                const Icon(Icons.person),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =============================
            // AMOUNT
            // =============================
            TextField(

              controller: amountController,

              keyboardType:
              TextInputType.number,

              decoration: InputDecoration(

                labelText: "Amount",

                prefixText: "₦ ",

                prefixIcon:
                const Icon(Icons.money),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =============================
            // NOTE
            // =============================
            TextField(

              controller: noteController,

              maxLines: 3,

              decoration: InputDecoration(

                labelText: "Note (Optional)",

                alignLabelWithHint: true,

                prefixIcon:
                const Icon(Icons.note),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // =============================
            // TRANSFER BUTTON
            // =============================
            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : sendTransfer,

                style: ElevatedButton.styleFrom(

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),

                ),

                child:

                isLoading

                    ? const CircularProgressIndicator()

                    : const Text(

                  "Send Money",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =============================
            // SECURITY INFO
            // =============================
            Container(

              padding:
              const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.green.shade50,

                borderRadius:
                BorderRadius.circular(15),

              ),

              child: const Row(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.security,
                    color: Colors.green,
                  ),

                  SizedBox(width: 12),

                  Expanded(

                    child: Text(

                      "All transfers are protected with fraud detection and secure verification.",

                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
