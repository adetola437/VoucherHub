import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../cubit/vouchers_cubit.dart';
import '../../data/models/voucher_model.dart';

part '../contracts/vouchers.dart';
part '../views/vouchers.dart';

class VouchersScreen extends StatefulWidget {
  static const route = 'vouchers';
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen>
    implements VouchersControllerContract {
  late final VouchersViewContract view;

  @override
  late VouchersCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = sl<VouchersCubit>();
    view = VouchersView(controller: this);
    loadVouchers();
  }

  @override
  void loadVouchers() {
    cubit.loadVouchers();
  }

  @override
  Future<void> refreshVouchers() async {
    return await cubit.loadVouchers();
  }

  @override
  void onVoucherTapped(VoucherModel voucher) {
    // Navigate to voucher detail
    context.pushNamed('voucher-detail', extra: voucher);
  }

  @override
  void navigateToProducts() {
    context.go('/products');
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
