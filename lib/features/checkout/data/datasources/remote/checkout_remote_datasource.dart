import 'package:dartz/dartz.dart';
import '../../../../../core/api/client/api_service.dart';
import '../../../../../core/api/exception/failure.dart';
import '../../models/checkout_model.dart';


abstract class ICheckoutRemoteDataSource {
  Future<Either<Failure, CheckoutTotalModel>> calculateTotal();
  Future<Either<Failure, CheckoutResultModel>> checkout();
}

class CheckoutRemoteDataSourceImpl implements ICheckoutRemoteDataSource {
  final IApiService apiService;
  CheckoutRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, CheckoutTotalModel>> calculateTotal() =>
      apiService.get<CheckoutTotalModel>(
        '/cart/total',
        
        fromJson: (json) =>
            CheckoutTotalModel.fromJson(json as Map<String, dynamic>),
      );

  @override
  Future<Either<Failure, CheckoutResultModel>> checkout() =>
      apiService.post<CheckoutResultModel>(
        '/checkout',
        body: {},
        fromJson: (json) =>
            CheckoutResultModel.fromJson(json as Map<String, dynamic>),
      );
}
