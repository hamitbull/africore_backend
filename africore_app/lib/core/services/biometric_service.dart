import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {

  final LocalAuthentication auth =
  LocalAuthentication();

  // =============================
  // CHECK BIOMETRIC SUPPORT
  // =============================
  Future<bool> isBiometricAvailable() async {

    try {

      final canCheck =
      await auth.canCheckBiometrics;

      final isSupported =
      await auth.isDeviceSupported();

      return canCheck && isSupported;

    } on PlatformException {

      return false;

    }
  }

  // =============================
  // GET AVAILABLE TYPES
  // =============================
  Future<List<BiometricType>>
  getAvailableBiometrics() async {

    try {

      return await auth.getAvailableBiometrics();

    } on PlatformException {

      return [];

    }
  }

  // =============================
  // AUTHENTICATE USER
  // =============================
  Future<bool> authenticate() async {

    try {

      return await auth.authenticate(

        localizedReason:
        "Authenticate to access AFRICORE",

        options: const AuthenticationOptions(

          biometricOnly: true,

          stickyAuth: true,

          sensitiveTransaction: true,

        ),
      );

    } on PlatformException {

      return false;

    }
  }
}
