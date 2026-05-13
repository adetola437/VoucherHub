import 'package:dartz/dartz.dart';
import '../../../../core/api/exception/failure.dart';
import '../datasources/remote/orders_remote_datasource.dart';
import '../models/order_model.dart';
import 'orders_repository.dart';

class OrdersRepositoryImpl implements IOrdersRepository {
  final IOrdersRemoteDataSource remoteDataSource;
  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() =>
      remoteDataSource.getOrders();

  @override
  Future<Either<Failure, OrderModel>> getOrderById(String orderId) =>
      remoteDataSource.getOrderById(orderId);
}
