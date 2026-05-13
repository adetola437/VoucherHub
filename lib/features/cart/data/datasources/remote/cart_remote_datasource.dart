import 'package:dartz/dartz.dart';
import '../../../../../core/api/client/api_service.dart';
import '../../../../../core/api/exception/failure.dart';
import '../../models/cart_model.dart';


abstract class ICartRemoteDataSource {
  Future<Either<Failure, CartModel>> getCart();
  Future<Either<Failure, CartModel>> addItem({
    required String productId,
    required double amount,
    required int quantity,
  });
  Future<Either<Failure, CartModel>> updateItem({
    required String cartItemId,
    required int quantity,
  });
  Future<Either<Failure, void>> removeItem(String cartItemId);
  Future<Either<Failure, void>> clearCart();
}

class CartRemoteDataSourceImpl implements ICartRemoteDataSource {
  final IApiService apiService;
  CartRemoteDataSourceImpl({required this.apiService});

  CartModel _parseCart(dynamic json) {
    if (json is Map<String, dynamic>) return CartModel.fromJson(json);
    return const CartModel(items: []);
  }

  @override
  Future<Either<Failure, CartModel>> getCart() =>
      apiService.get<CartModel>('/cart', fromJson: _parseCart);

  @override
  Future<Either<Failure, CartModel>> addItem({
    required String productId,
    required double amount,
    required int quantity,
  }) =>
      apiService.post<CartModel>(
        '/cart/items',
        body: {'productCode': productId, 'amount': amount, 'quantity': quantity},
        fromJson: _parseCart,
      );

  @override
  Future<Either<Failure, CartModel>> updateItem({
    required String cartItemId,
    required int quantity,
  }) =>
      apiService.put<CartModel>(
        '/cart/items/$cartItemId',
        body: {'quantity': quantity},
        fromJson: _parseCart,
      );

  @override
  Future<Either<Failure, void>> removeItem(String cartItemId) =>
      apiService.delete<void>(
        '/cart/items/$cartItemId',
        fromJson: (_) {},
      );

  @override
  Future<Either<Failure, void>> clearCart() =>
      apiService.delete<void>('/cart', fromJson: (_) {});
}
