import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../cart/cubit/cart_cubit.dart';
import '../../../cart/data/models/cart_model.dart';
import '../../cubit/checkout_cubit.dart';
import '../../data/models/checkout_model.dart';
import 'checkout_result.dart';

part '../contracts/checkout.dart';
part '../views/checkout.dart';

class CheckoutScreen extends StatefulWidget {
  static const route = 'checkout';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    implements CheckoutControllerContract {
  @override
  late CheckoutCubit cubit;
  @override
  late CartCubit cartCubit;
  late final CheckoutViewContract view;

  @override
  void initState() {
    super.initState();
    cubit = sl<CheckoutCubit>();
    cartCubit = sl<CartCubit>();
    view = CheckoutView(controller: this);
    cartCubit.loadCart();
    calculateTotal();
  }

  @override
  void calculateTotal() => cubit.calculateTotal();

  @override
  void placeOrder() => cubit.checkout();

  @override
  void navigateToResult(BuildContext context, dynamic result, CheckoutResultModel? resultModel) {
    context.pushReplacementNamed(
      CheckoutResultScreen.route,
      extra: resultModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return view.build(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}