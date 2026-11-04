class ApiEndpoints {
  // Set this at build time:
  // flutter build apk --release --dart-define=API_BASE_URL=https://your-api.example/api
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/me';
  static const String wallet = '/wallet/me';
  static const String transfer = '/transfer';
  static const String transactions = '/transactions/me';
  static const String notifications = '/notifications';
  static const String miniapps = '/miniapps';
  static const String kyc = '/kyc';
}
