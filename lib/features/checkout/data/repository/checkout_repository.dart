import 'package:dartz/dartz.dart';
import '../../../../core/api/exception/failure.dart';
import '../models/checkout_model.dart';

abstract class ICheckoutRepository {
  Future<Either<Failure, CheckoutTotalModel>> calculateTotal();
  Future<Either<Failure, CheckoutResultModel>> checkout();
}
