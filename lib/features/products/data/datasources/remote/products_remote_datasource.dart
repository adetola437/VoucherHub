import 'package:dartz/dartz.dart';
import '../../../../../core/api/client/api_service.dart';
import '../../../../../core/api/exception/failure.dart';
import '../../models/product_model.dart';


abstract class IProductsRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, ProductModel>> getProductById(String productId);
}

class ProductsRemoteDataSourceImpl implements IProductsRemoteDataSource {
  final IApiService apiService;
  ProductsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() {
    return apiService.get<List<ProductModel>>(
      '/suregifts/products',
      fromJson: (json) {
        final list = json is List
            ? json
            : (json as Map)['data'] is List
                ? (json as Map)['data'] as List
                : [];
        return list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String productId) {
    return apiService.get<ProductModel>(
      'suregifts/products/$productId',
      fromJson: (json) {
        final data = json is Map && json.containsKey('data') ? json['data'] : json;
        return ProductModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }
}
