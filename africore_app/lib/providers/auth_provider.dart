import 'package:flutter/material.dart';

import '../core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {

  final AuthService _authService =
      AuthService();

  bool isLoading = false;

  bool isLoggedIn = false;

  Map<String, dynamic>? user;

  // =============================
  // LOGIN
  // =============================
  Future<void> login({
    required String phone,
    required String password,
  }) async {

    isLoading = true;
    notifyListeners();

    try {

      final res = await _authService.login(
        phone: phone,
        password: password,
      );

      user = res["user"];
      isLoggedIn = true;

    } catch (e) {

      isLoggedIn = false;

    }

    isLoading = false;
    notifyListeners();
  }

  // =============================
  // REGISTER
  // =============================
  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {

    isLoading = true;
    notifyListeners();

    try {

      final res =
      await _authService.register(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );

      user = res["user"];
      isLoggedIn = true;

    } catch (e) {

      isLoggedIn = false;

    }

    isLoading = false;
    notifyListeners();
  }

  // =============================
  // LOGOUT
  // =============================
  Future<void> logout() async {

    await _authService.logout();

    user = null;
    isLoggedIn = false;

    notifyListeners();
  }
}
