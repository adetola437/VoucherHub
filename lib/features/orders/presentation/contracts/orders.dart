part of '../controllers/orders.dart';

abstract class OrdersControllerContract {
  late OrdersCubit cubit;

  void loadOrders();
  Future<void> refreshOrders();
  void onOrderTapped(BuildContext context, OrderModel order);
  void navigateToBrowseCards(BuildContext context);
}

abstract class OrdersViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {
  // Base contract for all views
}
