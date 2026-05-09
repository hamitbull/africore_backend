import 'package:flutter/material.dart';

import '../core/services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {

  final WalletService _walletService =
      WalletService();

  bool isLoading = false;

  double balance = 0;

  List transactions = [];

  Map<String, dynamic>? virtualAccount;

  // =============================
  // LOAD WALLET
  // =============================
  Future<void> loadWallet() async {

    isLoading = true;
    notifyListeners();

    try {

      final data =
      await _walletService.getWallet();

      balance =
      data["wallet"]["balance"]
          .toDouble();

      transactions =
      data["transactions"];

      virtualAccount =
      data["user"]["virtualAccount"];

    } catch (e) {

      debugPrint(e.toString());

    }

    isLoading = false;
    notifyListeners();
  }

  // =============================
  // TRANSFER
  // =============================
  Future<void> transfer({
    required String receiver,
    required double amount,
  }) async {

    await _walletService.transfer(
      receiverAfroId: receiver,
      amount: amount,
    );

    await loadWallet();
  }
}
