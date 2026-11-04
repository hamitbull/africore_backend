import '../config/api_endpoints.dart';
import 'api_service.dart';

class WalletService {
  final ApiService _api = ApiService.instance;

  Future<Map<String, dynamic>> getWallet() async {
    final response = await _api.get(
      ApiEndpoints.wallet,
      authenticated: true,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> transfer({
    required String receiverAfroId,
    required double amount,
  }) async {
    if (amount <= 0 || !amount.isFinite) {
      throw ArgumentError.value(amount, 'amount', 'Amount must be greater than zero.');
    }
    final response = await _api.post(
      ApiEndpoints.transfer,
      {'receiverAfroId': receiverAfroId.trim(), 'amount': amount},
      authenticated: true,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<dynamic>> getTransactions() async {
    final response = await _api.get(
      ApiEndpoints.transactions,
      authenticated: true,
    );
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data['transactions'] is List) {
      return List<dynamic>.from(data['transactions'] as List);
    }
    if (data is Map && data['data'] is List) {
      return List<dynamic>.from(data['data'] as List);
    }
    return <dynamic>[];
  }

  Future<Map<String, dynamic>> requestPayout({
    required double amount,
    required String bankCode,
    required String accountNumber,
  }) async {
    final response = await _api.post(
      '/payout/request',
      {
        'amount': amount,
        'bankCode': bankCode,
        'accountNumber': accountNumber,
      },
      authenticated: true,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getVirtualAccount() => getWallet();
}
