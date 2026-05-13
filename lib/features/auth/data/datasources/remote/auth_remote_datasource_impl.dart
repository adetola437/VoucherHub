import 'package:dartz/dartz.dart';
import 'package:voucher_hub/features/auth/data/models/login_data.dart';
import '../../../../../core/api/client/api_service.dart';
import '../../../../../core/api/exception/failure.dart';
import '../../models/auth_models.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final IApiService apiService;
  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, LoginResponse>> login(String email, String password) {
    return apiService.post<LoginResponse>(
      '/auth/login',
      body: LoginRequest(email: email, password: password).toJson(),
      fromJson: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
