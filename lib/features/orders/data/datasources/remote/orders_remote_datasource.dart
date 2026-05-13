import 'package:dartz/dartz.dart';
import '../../../../../core/api/client/api_service.dart';
import '../../../../../core/api/exception/failure.dart';
import '../../models/order_model.dart';


abstract class IOrdersRemoteDataSource {
  Future<Either<Failure, List<OrderModel>>> getOrders();
  Future<Either<Failure, OrderModel>> getOrderById(String orderId);
}

class OrdersRemoteDataSourceImpl implements IOrdersRemoteDataSource {
  final IApiService apiService;
  OrdersRemoteDataSourceImpl({required this.apiService});

  List<OrderModel> _parseList(dynamic json) {
    final list = json is List
        ? json
        : (json is Map && json['data'] is List)
            ? json['data'] as List
            : [];
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() =>
      apiService.get<List<OrderModel>>(
        '/orders',
        fromJson: _parseList,
      );

  @override
  Future<Either<Failure, OrderModel>> getOrderById(String orderId) =>
      apiService.get<OrderModel>(
        '/orders/$orderId',
        fromJson: (json) {
          final data =
              json is Map && json.containsKey('data') ? json['data'] : json;
          return OrderModel.fromJson(data as Map<String, dynamic>);
        },
      );
}
