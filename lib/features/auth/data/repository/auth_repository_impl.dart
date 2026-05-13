import 'dart:convert';
import 'package:dartz/dartz.dart';

import '../../../../core/api/exception/failure.dart';
import '../../../../core/storage/local_storage.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth_models.dart';
import '../models/login_data.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<Either<Failure, LoginResponse>> login(
          String email, String password) async =>
      remoteDataSource.login(email, password);

  @override
  Future<void> saveSession({
    required String token,
    required DateTime expiresAt,
    required AuthUser user,
  }) async {
    await Future.wait([
      localStorage.saveAccessToken(token),
      localStorage.saveTokenExpiry(expiresAt),
      localStorage.saveUserData(jsonEncode(user.toJson())),
    ]);
  }

  @override
  Future<String?> getSavedToken() => localStorage.getAccessToken();

  @override
  Future<DateTime?> getTokenExpiry() => localStorage.getTokenExpiry();

  @override
  Future<String?> getSavedUser() => localStorage.getUserData();

  @override
  Future<void> logout() => localStorage.clearAll();
}