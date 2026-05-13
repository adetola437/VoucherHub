import 'package:dartz/dartz.dart';

import '../../../../core/api/exception/failure.dart';
import '../models/auth_models.dart';
import '../models/login_data.dart';

abstract class IAuthRepository {
  Future<Either<Failure, LoginResponse>> login(String email, String password);

  /// Persist token, expiry and user data after a successful login.
  Future<void> saveSession({
    required String token,
    required DateTime expiresAt,
    required AuthUser user,
  });

  Future<String?> getSavedToken();
  Future<DateTime?> getTokenExpiry();
  Future<String?> getSavedUser();

  /// Wipe all session data (token, expiry, user).
  Future<void> logout();
}