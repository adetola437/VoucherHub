part of '../controllers/checkout_result.dart';

abstract class CheckoutResultControllerContract {
  late CheckoutResultModel result;

  bool get isSuccess;
  bool get isPending;
  bool get isFailed;

  Color get statusColor;
  IconData get statusIcon;
  String get statusTitle;
  String get statusSubtitle;

  void navigateToVouchers(BuildContext context);
  void navigateToOrders(BuildContext context);
  void navigateToCart(BuildContext context);
  void navigateToCatalogue(BuildContext context);
}

abstract class CheckoutResultViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {
  // Base contract for all views
}