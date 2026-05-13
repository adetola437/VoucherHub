part of '../controllers/product_catalogue.dart';

abstract class ProductCatalogueControllerContract {
  late ProductsCubit cubit;
  TextEditingController get searchCtrl;

  void loadProducts();
  void searchProducts(String query);
  void navigateToProductDetail(
    BuildContext context,
    ProductModel product,
  );
  void navigateToCart(BuildContext context);
  void navigateToProfile(BuildContext context);
  void navigateToOrders(BuildContext context);
  void navigateToVouchers(BuildContext context);
  void onBottomNavTap(BuildContext context, int index);
}

abstract class ProductCatalogueViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {
  // Base contract for all views
}
