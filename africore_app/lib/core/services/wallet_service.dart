import 'package:dio/dio.dart';

import 'storage_service.dart';

class WalletService {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://yourdomain.com/api",
      headers: {
        "Content-Type": "application/json"
      },
    ),
  );

  final StorageService storageService =
      StorageService();

  // =============================
  // GET AUTH HEADER
  // =============================
  Future<Options> _authOptions() async {

    final token =
    await storageService.getToken();

    return Options(
      headers: {
        "Authorization": "Bearer $token"
      },
    );
  }

  // =============================
  // GET WALLET
  // =============================
  Future<Map<String, dynamic>>
  getWallet() async {

    try {

      final options =
      await _authOptions();

      final response = await dio.get(
        "/wallet",
        options: options,
      );

      return response.data;

    } catch (e) {

      throw Exception(
        "Failed to fetch wallet",
      );

    }
  }

  // =============================
  // TRANSFER MONEY
  // =============================
  Future<Map<String, dynamic>>
  transfer({

    required String receiverAfroId,

    required double amount,

  }) async {

    try {

      final options =
      await _authOptions();

      final response = await dio.post(

        "/wallet/transfer",

        data: {

          "receiverAfroId":
          receiverAfroId,

          "amount":
          amount

        },

        options: options,
      );

      return response.data;

    } catch (e) {

      throw Exception(
        "Transfer failed",
      );

    }
  }

  // =============================
  // GET TRANSACTION HISTORY
  // =============================
  Future<List<dynamic>>
  getTransactions() async {

    try {

      final options =
      await _authOptions();

      final response = await dio.get(
        "/wallet/history",
        options: options,
      );

      return response.data;

    } catch (e) {

      throw Exception(
        "Failed to fetch transactions",
      );

    }
  }

  // =============================
  // REQUEST PAYOUT
  // =============================
  Future<Map<String, dynamic>>
  requestPayout({

    required double amount,

    required String bankCode,

    required String accountNumber,

  }) async {

    try {

      final options =
      await _authOptions();

      final response = await dio.post(

        "/payout/request",

        data: {

          "amount": amount,

          "bankCode": bankCode,

          "accountNumber":
          accountNumber

        },

        options: options,
      );

      return response.data;

    } catch (e) {

      throw Exception(
        "Payout request failed",
      );

    }
  }

  // =============================
  // GET VIRTUAL ACCOUNT
  // =============================
  Future<Map<String, dynamic>>
  getVirtualAccount() async {

    try {

      final options =
      await _authOptions();

      final response = await dio.get(
        "/wallet/virtual-account",
        options: options,
      );

      return response.data;

    } catch (e) {

      throw Exception(
        "Failed to fetch account",
      );

    }
  }
}
