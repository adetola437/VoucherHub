part of '../controllers/vouchers.dart';

abstract class VouchersControllerContract {
  late VouchersCubit cubit;

  void loadVouchers();
  Future<void> refreshVouchers();
  void onVoucherTapped(VoucherModel voucher);
  void navigateToProducts();
}

abstract class VouchersViewContract extends BaseViewContract {
  void showErrorDialog(String message);
  Widget build(BuildContext context);
}

abstract class BaseViewContract {
  // Base contract for all views
}
