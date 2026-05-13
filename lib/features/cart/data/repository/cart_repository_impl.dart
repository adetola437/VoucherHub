import 'package:dartz/dartz.dart';
import '../../../../core/api/exception/failure.dart';
import '../datasources/remote/cart_remote_datasource.dart';
import '../models/cart_model.dart';
import 'cart_repository.dart';

class CartRepositoryImpl implements ICartRepository {
  final ICartRemoteDataSource remoteDataSource;
  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CartModel>> getCart() =>
      remoteDataSource.getCart();

  @override
  Future<Either<Failure, CartModel>> addToCart({
    required String productCode,
    required double amount,
    required int quantity,
  }) =>
      remoteDataSource.addItem(
          productId:  productCode, amount: amount, quantity: quantity);

  @override
  Future<Either<Failure, CartModel>> updateCartItem({
    required String cartItemId,
    required int quantity,
  }) =>
      remoteDataSource.updateItem(
          cartItemId: cartItemId, quantity: quantity);

  @override
  Future<Either<Failure, void>> removeCartItem(String cartItemId) =>
      remoteDataSource.removeItem(cartItemId);

  @override
  Future<Either<Failure, void>> clearCart() => remoteDataSource.clearCart();
}
