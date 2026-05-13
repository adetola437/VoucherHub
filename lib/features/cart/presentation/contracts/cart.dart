part of '../controllers/cart.dart';

abstract class CartControllerContract {
  void loadCart();
  void clearCart(BuildContext context);
  void updateItem(String cartItemId, int quantity);
  void removeItem(String cartItemId);
  void checkout(BuildContext context);
  void navigateToCatalogue(BuildContext context);
}

abstract class CartViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {}