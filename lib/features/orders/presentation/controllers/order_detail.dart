import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../cubit/orders_cubit.dart';
import '../../data/models/order_model.dart';

part '../contracts/order_detail.dart';
part '../views/order_detail.dart';

class OrderDetailScreen extends StatefulWidget {
  static const route = 'order-detail';
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    implements OrderDetailControllerContract {
  late final OrderDetailViewContract view;

  @override
  late OrdersCubit cubit;

  @override
  OrderModel get order => widget.order;

  @override
  void initState() {
    super.initState();
    cubit = sl<OrdersCubit>();
    view = OrderDetailView(controller: this);
    loadOrderDetail();
  }

  @override
  void loadOrderDetail() {
    cubit.loadOrderDetail(order.id);
  }

  @override
  void navigateToVouchers(BuildContext context) {
    context.push('/vouchers');
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
