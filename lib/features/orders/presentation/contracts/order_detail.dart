part of '../controllers/order_detail.dart';

abstract class OrderDetailControllerContract {
  late OrdersCubit cubit;
  OrderModel get order;

  void loadOrderDetail();
  void navigateToVouchers(BuildContext context);
}

abstract class OrderDetailViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {
  // Base contract for all views
}
