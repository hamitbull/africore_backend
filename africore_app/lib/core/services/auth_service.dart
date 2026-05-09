import 'package:dio/dio.dart';

import 'storage_service.dart';

class AuthService {

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
  // REGISTER USER
  // =============================
  Future<Map<String, dynamic>>
  register({

    required String fullName,

    required String phone,

    required String email,

    required String password,

  }) async {

    try {

      final response = await dio.post(

        "/auth/register",

        data: {

          "fullName": fullName,

          "phone": phone,

          "email": email,

          "password": password

        },
      );

      // =============================
      // SAVE JWT TOKEN
      // =============================
      final token =
      response.data["token"];

      if (token != null) {

        await storageService.saveToken(
          token,
        );

      }

      return response.data;

    } catch (e) {

      throw Exception(
        "Registration failed",
      );

    }
  }

  // =============================
  // LOGIN USER
  // =============================
  Future<Map<String, dynamic>>
  login({

    required String phone,

    required String password,

  }) async {

    try {

      final response = await dio.post(

        "/auth/login",

        data: {

          "phone": phone,

          "password": password

        },
      );

      // =============================
      // SAVE JWT TOKEN
      // =============================
      final token =
      response.data["token"];

      if (token != null) {

        await storageService.saveToken(
          token,
        );

      }

      return response.data;

    } catch (e) {

      throw Exception(
        "Login failed",
      );

    }
  }

  // =============================
  // LOGOUT USER
  // =============================
  Future<void> logout() async {

    await storageService.clearToken();
  }

  // =============================
  // GET SAVED TOKEN
  // =============================
  Future<String?> getToken() async {

    return await storageService.getToken();
  }

  // =============================
  // CHECK LOGIN STATUS
  // =============================
  Future<bool> isLoggedIn() async {

    final token =
    await storageService.getToken();

    return token != null;
  }

  // =============================
  // FETCH CURRENT USER
  // =============================
  Future<Map<String, dynamic>>
  getProfile() async {

    try {

      final token =
      await storageService.getToken();

      final response = await dio.get(

        "/auth/profile",

        options: Options(

          headers: {
            "Authorization":
            "Bearer $token"
          },
        ),
      );

      return response.data;

    } catch (e) {

      throw Exception(
        "Failed to load profile",
      );

    }
  }

  // =============================
  // UPDATE PROFILE
  // =============================
  Future<Map<String, dynamic>>
  updateProfile({

    required String fullName,

    required String email,

  }) async {

    try {

      final token =
      await storageService.getToken();

      final response = await dio.put(

        "/auth/profile",

        data: {

          "fullName": fullName,

          "email": email

        },

        options: Options(

          headers: {
            "Authorization":
            "Bearer $token"
          },
        ),
      );

      return response.data;

    } catch (e) {

      throw Exception(
        "Failed to update profile",
      );

    }
  }

  // =============================
  // VERIFY OTP
  // =============================
  Future<Map<String, dynamic>>
  verifyOTP({

    required String phone,

    required String otp,

  }) async {

    try {

      final response = await dio.post(

        "/auth/verify-otp",

        data: {

          "phone": phone,

          "otp": otp

        },
      );

      return response.data;

    } catch (e) {

      throw Exception(
        "OTP verification failed",
      );

    }
  }
}
