import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voucher_hub/features/auth/presentation/controllers/splash.dart' show SplashScreen;


import '../../features/auth/presentation/controllers/login.dart';

import '../../features/checkout/data/models/checkout_model.dart';
import '../../features/products/data/models/product_model.dart';
import '../../features/products/presentation/controllers/product_catalogue.dart';
import '../../features/products/presentation/controllers/product_detail.dart';
import '../../features/cart/presentation/controllers/cart.dart';
import '../../features/checkout/presentation/controllers/checkout.dart';
import '../../features/checkout/presentation/controllers/checkout_result.dart';
import '../../features/orders/presentation/controllers/orders.dart';
import '../../features/orders/presentation/controllers/order_detail.dart';
import '../../features/orders/data/models/order_model.dart';
import '../../features/vouchers/presentation/controllers/vouchers.dart';
import '../../features/vouchers/presentation/controllers/voucher_detail.dart';
import '../../features/vouchers/data/models/voucher_model.dart';
import '../../features/profile/presentation/controllers/profile.dart';

import '../shell/main_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  AppRouter._();

  static final _catalogueKey =
      GlobalKey<NavigatorState>(debugLabel: 'catalogue');
  static final _cartKey = GlobalKey<NavigatorState>(debugLabel: 'cart');
  static final _ordersKey = GlobalKey<NavigatorState>(debugLabel: 'orders');
  static final _vouchersKey =
      GlobalKey<NavigatorState>(debugLabel: 'vouchers');
  static final _profileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    // Always start at splash — it resolves auth and redirects accordingly
    initialLocation: '/splash',
    routes: [
      // ── Splash ─────────────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        name: SplashScreen.route,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const SplashScreen(),
      ),

      // ── Auth ───────────────────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        name: LoginScreen.route,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const LoginScreen(),
      ),

      // ── Full-screen routes above the shell ─────────────────────────────────
      GoRoute(
        path: '/products/detail',
        name: ProductDetailScreen.route,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final product = state.extra as ProductModel;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: '/checkout',
        name: CheckoutScreen.route,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/checkout/result',
        name: CheckoutResultScreen.route,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final result = state.extra as CheckoutResultModel;
          return CheckoutResultScreen(result: result);
        },
      ),
      GoRoute(
        path: '/orders/detail',
        name: OrderDetailScreen.route,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final order = state.extra as OrderModel;
          return OrderDetailScreen(order: order);
        },
      ),
      GoRoute(
        path: '/vouchers/detail',
        name: VoucherDetailScreen.route,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final voucher = state.extra as VoucherModel;
          return VoucherDetailScreen(voucher: voucher);
        },
      ),

      // ── Shell — bottom nav ─────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _catalogueKey,
            routes: [
              GoRoute(
                path: '/products',
                name: ProductCatalogueScreen.route,
                builder: (_, __) => const ProductCatalogueScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _cartKey,
            routes: [
              GoRoute(
                path: '/cart',
                name: CartScreen.route,
                builder: (_, __) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _ordersKey,
            routes: [
              GoRoute(
                path: '/orders',
                name: OrdersScreen.route,
                builder: (_, __) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _vouchersKey,
            routes: [
              GoRoute(
                path: '/vouchers',
                name: VouchersScreen.route,
                builder: (_, __) => const VouchersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: ProfileScreen.route,
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}