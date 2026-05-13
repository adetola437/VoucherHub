import 'package:dartz/dartz.dart';
import '../../../../core/api/exception/failure.dart';
import '../datasources/remote/checkout_remote_datasource.dart';
import '../models/checkout_model.dart';
import 'checkout_repository.dart';

class CheckoutRepositoryImpl implements ICheckoutRepository {
  final ICheckoutRemoteDataSource remoteDataSource;
  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CheckoutTotalModel>> calculateTotal() =>
      remoteDataSource.calculateTotal();

  @override
  Future<Either<Failure, CheckoutResultModel>> checkout() =>
      remoteDataSource.checkout();
}
