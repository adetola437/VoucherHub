import 'package:dartz/dartz.dart';
import '../../../../core/api/exception/failure.dart';
import '../models/order_model.dart';

abstract class IOrdersRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders();
  Future<Either<Failure, OrderModel>> getOrderById(String orderId);
}
