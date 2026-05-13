import 'package:dartz/dartz.dart';

import '../../../../core/api/exception/failure.dart';
import '../models/product_model.dart';

abstract class IProductsRepository {
  /// Fetches products from the remote API and caches the result locally.
  Future<Either<Failure, List<ProductModel>>> getProducts();

  /// Returns the locally cached catalogue, or null if nothing is cached yet.
  Future<List<ProductModel>?> getCachedProducts();

  /// Clears the locally cached catalogue.
  Future<void> clearCachedProducts();

  Future<Either<Failure, ProductModel>> getProductById(String productId);
}