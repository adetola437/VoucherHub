import 'package:dartz/dartz.dart';
import 'package:voucher_hub/features/auth/data/models/login_data.dart';
import '../../../../../core/api/exception/failure.dart';
import '../../models/auth_models.dart';


abstract class IAuthRemoteDataSource {
  Future<Either<Failure, LoginResponse>> login(String email, String password);
}
