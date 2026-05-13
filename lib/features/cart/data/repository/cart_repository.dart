import 'package:dartz/dartz.dart';
import '../../../../core/api/exception/failure.dart';
import '../models/cart_model.dart';

abstract class ICartRepository {
  Future<Either<Failure, CartModel>> getCart();
  Future<Either<Failure, CartModel>> addToCart({
    required String productCode,
    required double amount,
    required int quantity,
  });
  Future<Either<Failure, CartModel>> updateCartItem({
    required String cartItemId,
    required int quantity,
  });
  Future<Either<Failure, void>> removeCartItem(String cartItemId);
  Future<Either<Failure, void>> clearCart();
}
