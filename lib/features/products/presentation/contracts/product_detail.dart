part of '../controllers/product_detail.dart';

abstract class ProductDetailControllerContract {
  late CartCubit cartCubit;
  ProductModel get product;

  double? get selectedAmount;
  TextEditingController get amountCtrl;
  int get quantity;
  String? get amountError;

  void setSelectedAmount(double? amount);
  void setQuantity(int quantity);
  void setAmountError(String? error);
  void addToCart();
  void validateAmount();
  void navigateToCart(BuildContext context);
}

abstract class ProductDetailViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {
  // Base contract for all views
}
