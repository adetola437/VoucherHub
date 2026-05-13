import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:voucher_hub/features/products/cubit/products_cubit.dart';
import 'package:voucher_hub/features/vouchers/cubit/vouchers_cubit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../orders/cubit/orders_cubit.dart';
import '../../data/models/checkout_model.dart';


part '../contracts/checkout_result.dart';
part '../views/checkout_result.dart';

class CheckoutResultScreen extends StatefulWidget {
  static const route = 'checkout-result';
  final CheckoutResultModel result;

  const CheckoutResultScreen({super.key, required this.result});

  @override
  State<CheckoutResultScreen> createState() => _CheckoutResultScreenState();
}

class _CheckoutResultScreenState extends State<CheckoutResultScreen>
    implements CheckoutResultControllerContract {
  @override
  late CheckoutResultModel result;
  late final CheckoutResultViewContract view;

  @override
  void initState() {
    super.initState();
    result = widget.result;
    view = CheckoutResultView(controller: this);
  }

  @override
  bool get isSuccess => result.isSuccessful;

  @override
  bool get isPending => result.isPending;

  @override
  bool get isFailed => result.isFailed;

  @override
  Color get statusColor {
    if (isSuccess) return AppColors.success;
    if (isPending) return AppColors.warning;
    return AppColors.error;
  }

  @override
  IconData get statusIcon {
    if (isSuccess) return Icons.check_circle_outline_rounded;
    if (isPending) return Icons.hourglass_top_rounded;
    return Icons.cancel_outlined;
  }

  @override
  String get statusTitle {
    if (isSuccess) return 'Order Placed!';
    if (isPending) return 'Processing...';
    return 'Order Failed';
  }

  @override
  String get statusSubtitle {
    return result.message ??
        (isSuccess
            ? 'Your gift cards are being processed.'
            : isPending
                ? 'Your order is being processed. Check back shortly.'
                : 'Something went wrong. Please try again.');
  }

  @override
  void navigateToVouchers(BuildContext context){

    GetIt.I.get<VouchersCubit>().loadVouchers(); 
        context.go('/vouchers'); 
  }

  @override
  void navigateToOrders(BuildContext context) {
    GetIt.I.get<OrdersCubit>().loadOrders();
    context.go('/orders');
  }

  @override
  void navigateToCart(BuildContext context) => context.go('/cart');

  @override
  void navigateToCatalogue(BuildContext context){
    GetIt.I.get<ProductsCubit>().loadProducts();
    context.go('/products');
  }

  @override
  Widget build(BuildContext context) {
    return view.build(context);
  }
}