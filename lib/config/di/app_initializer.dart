import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../config/flavor/app_constants.dart';
import '../../core/api/client/api_client.dart';
import '../../core/api/client/api_client_impl.dart';
import '../../core/api/client/api_service.dart';
import '../../core/api/client/api_service_impl.dart';
import '../../core/network/network_info.dart';
import '../../core/network/network_info_impl.dart';
import '../../core/storage/local_storage.dart';
import '../../core/storage/local_storage_impl.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/secure_storage_impl.dart';

// Auth
import '../../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/cubit/auth_cubit.dart';

// Products
import '../../features/products/data/datasources/remote/products_remote_datasource.dart';
import '../../features/products/data/datasources/remote/products_remote_datasource_impl.dart';
import '../../features/products/data/repository/products_repository.dart';
import '../../features/products/data/repository/products_repository_impl.dart';
import '../../features/products/cubit/products_cubit.dart';

// Cart
import '../../features/cart/data/datasources/remote/cart_remote_datasource.dart';
import '../../features/cart/data/datasources/remote/cart_remote_datasource_impl.dart';
import '../../features/cart/data/repository/cart_repository.dart';
import '../../features/cart/data/repository/cart_repository_impl.dart';
import '../../features/cart/cubit/cart_cubit.dart';

// Checkout
import '../../features/checkout/data/datasources/remote/checkout_remote_datasource.dart';
import '../../features/checkout/data/datasources/remote/checkout_remote_datasource_impl.dart';
import '../../features/checkout/data/repository/checkout_repository.dart';
import '../../features/checkout/data/repository/checkout_repository_impl.dart';
import '../../features/checkout/cubit/checkout_cubit.dart';

// Orders
import '../../features/orders/data/datasources/remote/orders_remote_datasource.dart';
import '../../features/orders/data/datasources/remote/orders_remote_datasource_impl.dart';
import '../../features/orders/data/repository/orders_repository.dart';
import '../../features/orders/data/repository/orders_repository_impl.dart';
import '../../features/orders/cubit/orders_cubit.dart';

// Vouchers
import '../../features/vouchers/data/datasources/remote/vouchers_remote_datasource.dart';
import '../../features/vouchers/data/datasources/remote/vouchers_remote_datasource_impl.dart';
import '../../features/vouchers/data/repository/vouchers_repository.dart';
import '../../features/vouchers/data/repository/vouchers_repository_impl.dart';
import '../../features/vouchers/cubit/vouchers_cubit.dart';

final GetIt sl = GetIt.instance;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppInitializer {
  AppInitializer._();

  static Future<void> init() async {
    // 1. Load .env first — AppConstants.baseUrl etc. depend on it
    await AppConstants.load();

    final prefs = await SharedPreferences.getInstance();

    // 2. Register in dependency order
    _registerCore(prefs);
    _registerDataSources();
    _registerRepositories();
    _registerCubits();
  }

  static void _registerCore(SharedPreferences prefs) {
    sl.registerSingleton<SharedPreferences>(prefs);
    sl.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
    sl.registerLazySingleton<SecureStorage>(
        () => SecureStorageImpl(secureStorage: sl()));
    sl.registerLazySingleton<LocalStorage>(
        () => LocalStorageImpl(prefs: sl(), secureStorage: sl()));

    sl.registerLazySingleton<IApiClient>(
        () => ApiClientImpl(networkInfo: sl(), localStorage: sl()));
    sl.registerLazySingleton<IApiService>(
        () => ApiServiceImpl(apiClient: sl()));
  }

  static void _registerDataSources() {
    sl.registerLazySingleton<IAuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(apiService: sl()));
    sl.registerLazySingleton<IProductsRemoteDataSource>(
        () => ProductsRemoteDataSourceImpl(apiService: sl()));
    sl.registerLazySingleton<ICartRemoteDataSource>(
        () => CartRemoteDataSourceImpl(apiService: sl()));
    sl.registerLazySingleton<ICheckoutRemoteDataSource>(
        () => CheckoutRemoteDataSourceImpl(apiService: sl()));
    sl.registerLazySingleton<IOrdersRemoteDataSource>(
        () => OrdersRemoteDataSourceImpl(apiService: sl()));
    sl.registerLazySingleton<IVouchersRemoteDataSource>(
        () => VouchersRemoteDataSourceImpl(apiService: sl()));
  }

  static void _registerRepositories() {
    sl.registerLazySingleton<IAuthRepository>(() =>
        AuthRepositoryImpl(remoteDataSource: sl(), localStorage: sl()));

    // ProductsRepositoryImpl now also needs localStorage for catalogue cache
    sl.registerLazySingleton<IProductsRepository>(() =>
        ProductsRepositoryImpl(remoteDataSource: sl(), localStorage: sl()));

    sl.registerLazySingleton<ICartRepository>(
        () => CartRepositoryImpl(remoteDataSource: sl()));
    sl.registerLazySingleton<ICheckoutRepository>(
        () => CheckoutRepositoryImpl(remoteDataSource: sl()));
    sl.registerLazySingleton<IOrdersRepository>(
        () => OrdersRepositoryImpl(remoteDataSource: sl()));
    sl.registerLazySingleton<IVouchersRepository>(
        () => VouchersRepositoryImpl(remoteDataSource: sl()));
  }

  static void _registerCubits() {
    sl.registerLazySingleton<AuthCubit>(() => AuthCubit(repository: sl()));
    sl.registerLazySingleton<CartCubit>(() => CartCubit(repository: sl()));
    sl.registerLazySingleton<ProductsCubit>(
        () => ProductsCubit(repository: sl()));
    sl.registerLazySingleton<CheckoutCubit>(
        () => CheckoutCubit(repository: sl()));
    sl.registerLazySingleton<OrdersCubit>(
        () => OrdersCubit(repository: sl()));
    sl.registerLazySingleton<VouchersCubit>(
        () => VouchersCubit(repository: sl()));
  }
}