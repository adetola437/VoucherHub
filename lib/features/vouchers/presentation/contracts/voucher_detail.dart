part of '../controllers/voucher_detail.dart';

abstract class VoucherDetailControllerContract {
  late VouchersCubit cubit;
  VoucherModel get voucher;

  void loadVoucherDetail();
  void copyToClipboard(BuildContext context, String value, String label);
  Future<void> launchUrl(String url);
}

abstract class VoucherDetailViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {
  // Base contract for all views
}
