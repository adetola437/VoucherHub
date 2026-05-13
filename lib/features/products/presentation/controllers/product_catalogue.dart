import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../cubit/products_cubit.dart';
import '../../data/models/product_model.dart';
import '../../../cart/cubit/cart_cubit.dart';
import 'product_detail.dart';

part '../contracts/product_catalogue.dart';
part '../views/product_catalogue.dart';

class ProductCatalogueScreen extends StatefulWidget {
  static const route = 'products';
  const ProductCatalogueScreen({super.key});

  @override
  State<ProductCatalogueScreen> createState() => _ProductCatalogueScreenState();
}

class _ProductCatalogueScreenState extends State<ProductCatalogueScreen>
    implements ProductCatalogueControllerContract {
  late final ProductCatalogueViewContract view;

  @override
  late ProductsCubit cubit;

  @override
  late TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
    cubit = sl<ProductsCubit>();
    view = ProductCatalogueView(controller: this);
    loadProducts();
  }

  @override
  void loadProducts() {
    cubit.loadProducts();
  }

  @override
  void searchProducts(String query) {
    cubit.search(query);
  }

  @override
  void navigateToProductDetail(BuildContext context, ProductModel product) {
    context.pushNamed(ProductDetailScreen.route, extra: product);
  }

  @override
  void navigateToCart(BuildContext context) {
    context.go('/cart');
  }

  @override
  void navigateToProfile(BuildContext context) {
    context.go('/profile');
  }

  @override
  void navigateToOrders(BuildContext context) {
    context.go('/orders');
  }

  @override
  void navigateToVouchers(BuildContext context) {
    context.go('/vouchers');
  }

  @override
  void onBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/products');
        break;
      case 1:
        navigateToCart(context);
        break;
      case 2:
        navigateToOrders(context);
        break;
      case 3:
        navigateToVouchers(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return view.build(context);
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}
