import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/product_model.dart';
import '../data/repository/products_repository.dart';

// ─── States ───────────────────────────────────────────────────────────────────
abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}
class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  final String? searchQuery;

  const ProductsLoaded(this.products, {this.searchQuery});

  List<ProductModel> get filtered {
    if (searchQuery == null || searchQuery!.isEmpty) return products;
    final q = searchQuery!.toLowerCase();
    return products
        .where((p) =>
            (p.name?.toLowerCase().contains(q) ?? false) ||
            (p.category?.toLowerCase().contains(q) ?? false) ||
            (p.country?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  @override
  List<Object?> get props => [products, searchQuery];
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProductDetailLoading extends ProductsState {}

class ProductDetailLoaded extends ProductsState {
  final ProductModel product;
  const ProductDetailLoaded(this.product);
  @override
  List<Object?> get props => [product];
}

// ─── Cubit ────────────────────────────────────────────────────────────────────
class ProductsCubit extends Cubit<ProductsState> {
  final IProductsRepository repository;
  ProductsCubit({required this.repository}) : super(ProductsInitial());

  Future<void> loadProducts() async {
    emit(ProductsLoading());
    final result = await repository.getProducts();
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  void search(String query) {
    final current = state;
    if (current is ProductsLoaded) {
      emit(ProductsLoaded(current.products, searchQuery: query));
    }
  }

  Future<void> loadProductDetail(String productId) async {
    emit(ProductDetailLoading());
    final result = await repository.getProductById(productId);
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }
}
