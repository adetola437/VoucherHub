import 'package:shared_preferences/shared_preferences.dart';

import '../../config/flavor/app_constants.dart';
import 'local_storage.dart';
import 'secure_storage.dart';

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences prefs;
  final SecureStorage secureStorage;

  LocalStorageImpl({required this.prefs, required this.secureStorage});

  // ── Token ──────────────────────────────────────────────────────────────────

  @override
  Future<void> saveAccessToken(String token) =>
      secureStorage.write(AppConstants.accessTokenKey, token);

  @override
  Future<String?> getAccessToken() =>
      secureStorage.read(AppConstants.accessTokenKey);

  @override
  Future<void> clearAccessToken() =>
      secureStorage.delete(AppConstants.accessTokenKey);

  // ── Token expiry ───────────────────────────────────────────────────────────

  @override
  Future<void> saveTokenExpiry(DateTime expiresAt) async =>
      prefs.setString(AppConstants.tokenExpiryKey, expiresAt.toIso8601String());

  @override
  Future<DateTime?> getTokenExpiry() async {
    final raw = prefs.getString(AppConstants.tokenExpiryKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  // ── User data ──────────────────────────────────────────────────────────────

  @override
  Future<void> saveUserData(String json) async =>
      prefs.setString(AppConstants.userKey, json);

  @override
  Future<String?> getUserData() async =>
      prefs.getString(AppConstants.userKey);

  // ── Product catalogue cache ────────────────────────────────────────────────

  @override
  Future<void> saveProductCatalogue(String json) async =>
      prefs.setString(AppConstants.productCatalogueKey, json);

  @override
  Future<String?> getProductCatalogue() async =>
      prefs.getString(AppConstants.productCatalogueKey);

  @override
  Future<void> clearProductCatalogue() async =>
      prefs.remove(AppConstants.productCatalogueKey);

  // ── Clear all ─────────────────────────────────────────────────────────────

  @override
  Future<void> clearAll() async {
    await secureStorage.deleteAll();
    await prefs.clear();
  }
}