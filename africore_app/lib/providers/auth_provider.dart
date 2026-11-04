import 'package:flutter/foundation.dart';

import '../core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isLoggedIn = false;
  Map<String, dynamic>? user;
  String? errorMessage;

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _authService.login(
        phone: phone,
        password: password,
      );
      user = result['user'] is Map
          ? Map<String, dynamic>.from(result['user'] as Map)
          : null;
      isLoggedIn = true;
    } catch (error) {
      isLoggedIn = false;
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _authService.register(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );
      user = result['user'] is Map
          ? Map<String, dynamic>.from(result['user'] as Map)
          : null;
      isLoggedIn = result['token'] != null;
    } catch (error) {
      isLoggedIn = false;
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    isLoggedIn = false;
    errorMessage = null;
    notifyListeners();
  }
}
