// lib/core/constants/api_constants.dart
class ApiConstants {
  // PocketBase URL - Change this for production
  static const String baseUrl = 'http://10.0.2.2:8090'; // For Android emulator
  // Use 'http://localhost:8090' for iOS simulator

  // Collection names
  static const String usersCollection = 'users';

  // OAuth redirect URL
  static const String oauthRedirectUrl = '$baseUrl/api/oauth2-redirect';
}