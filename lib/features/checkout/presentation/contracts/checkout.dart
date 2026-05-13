part of '../controllers/checkout.dart';

abstract class CheckoutControllerContract {
  void placeOrder();
  void calculateTotal();
  void navigateToResult(BuildContext context, dynamic result, CheckoutResultModel? resultModel) ;
}

abstract class CheckoutViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

