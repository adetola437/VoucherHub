import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/di/app_initializer.dart';
import '../../../core/api/client/api_client.dart';
import '../data/models/auth_models.dart';
import '../data/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository repository;

  AuthCubit({required this.repository}) : super(AuthInitial()) {
    _checkSavedSession();
  }

  // ── Session restore ────────────────────────────────────────────────────────

  Future<void> _checkSavedSession() async {
    final token = await repository.getSavedToken();
    if (token == null || token.isEmpty) {
      emit(AuthUnauthenticated());
      return;
    }

    // Check expiry
    final expiry = await repository.getTokenExpiry();
    final isExpired = expiry == null || DateTime.now().isAfter(expiry);
    if (isExpired) {
      await repository.logout(); // wipe stale data
      emit(AuthUnauthenticated());
      return;
    }

    // Restore user from SharedPreferences
    final userJson = await repository.getSavedUser();
    AuthUser? user;
    if (userJson != null) {
      try {
        user = AuthUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        // Corrupt data — treat as unauthenticated
      }
    }

    if (user == null) {
      await repository.logout();
      emit(AuthUnauthenticated());
      return;
    }

    // Re-apply token to Dio interceptor
    sl<IApiClient>().setToken(token);
    emit(AuthAuthenticated(user));
  }

  // ── Login ──────────────────────────────────────────────────────────────────

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await repository.login(email, password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (loginResponse) async {
        // Persist token + expiry + user before emitting success
        await repository.saveSession(
          token: loginResponse.accessToken,
          expiresAt: loginResponse.expiresAtUtc,
          user: loginResponse.user,
        );
        sl<IApiClient>().setToken(loginResponse.accessToken);
        emit(AuthAuthenticated(loginResponse.user));
      },
    );
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await repository.logout();
    sl<IApiClient>().clearToken();
    emit(AuthUnauthenticated());
  }
}