import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  /// Call [AppConstants.load()] once in [AppInitializer.init()] before
  /// accessing any env-backed value.
  static Future<void> load() => dotenv.load(fileName: '.env');

  // ── Base URLs (read from .env, fall back to compile-time defaults) ─────────
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? '';

  static String get swaggerUrl =>
      dotenv.env['SWAGGER_URL'] ?? '';

  // ── Storage keys ───────────────────────────────────────────────────────────
  static const String accessTokenKey     = 'access_token';
  static const String tokenExpiryKey     = 'token_expiry';
  static const String userKey            = 'user_data';
  static const String productCatalogueKey = 'product_catalogue';

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration sendTimeout    = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}