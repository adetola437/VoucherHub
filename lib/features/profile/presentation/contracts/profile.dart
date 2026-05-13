part of '../controllers/profile.dart';

abstract class ProfileControllerContract {
  late AuthCubit authCubit;

  void logout();
  void confirmLogout(BuildContext context);
  void navigateToOrders(BuildContext context);
  void navigateToVouchers(BuildContext context);
  void navigateToCart(BuildContext context);
}

abstract class ProfileViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {
  // Base contract for all views
}
