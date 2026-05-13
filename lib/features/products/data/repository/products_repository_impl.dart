import 'package:dartz/dartz.dart';
import 'dart:convert' show jsonEncode, jsonDecode;
import '../../../../core/api/exception/failure.dart';
import '../../../../core/storage/local_storage.dart';
import '../datasources/remote/products_remote_datasource.dart';
import '../models/product_model.dart';
import 'products_repository.dart';

class ProductsRepositoryImpl implements IProductsRepository {
  final IProductsRemoteDataSource remoteDataSource;
   final LocalStorage localStorage;

  ProductsRepositoryImpl({required this.remoteDataSource, required this.localStorage});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    final result = await remoteDataSource.getProducts();
    
    return result.fold(
      (failure) => Left(failure),
      (products) async {
        // Save products to cache as JSON
        final jsonString = _productsToJson(products);
        await localStorage.saveProductCatalogue(jsonString);
        return Right(products);
      },
    );
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String productId) async =>
     await remoteDataSource.getProductById(productId);

  @override
  Future<void> clearCachedProducts() async {
    await localStorage.clearProductCatalogue();
  }

  @override
  Future<List<ProductModel>?> getCachedProducts() async {
    final jsonString = await localStorage.getProductCatalogue();
    if (jsonString == null) return null;
    return _productsFromJson(jsonString);
  }

  // Helper methods to convert between JSON and ProductModel
  String _productsToJson(List<ProductModel> products) {
    final jsonList = products.map((product) {
      return {
        'code': product.id,
        'name': product.name,
        'imageUrl': product.imageUrl,
        'description': product.description,
        'currency': product.currency,
        'minValue': product.minValue,
        'maxValue': product.maxValue,
        'denominations': product.denominations,
        'redemptionDetails': product.redemptionInstructions?.split('\n'),
        'countries': product.country != null ? [product.country] : [],
        'categories': product.category != null ? [product.category] : [],
        'validity': product.validity != null
            ? {
                'type': product.validity!.type,
                'value': product.validity!.value,
              }
            : null,
      };
    }).toList();
    return jsonEncode(jsonList);
  }

  List<ProductModel> _productsFromJson(String json) {
    final jsonList = jsonDecode(json) as List;
    return jsonList
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
