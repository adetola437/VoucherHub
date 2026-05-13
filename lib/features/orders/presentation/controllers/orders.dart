import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../cubit/orders_cubit.dart';
import '../../data/models/order_model.dart';
import 'order_detail.dart';


part '../contracts/orders.dart';
part '../views/orders.dart';

class OrdersScreen extends StatefulWidget {
  static const route = 'orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    implements OrdersControllerContract {
  late final OrdersViewContract view;

  @override
  late OrdersCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = sl<OrdersCubit>();
    view = OrdersView(controller: this);
    loadOrders();
  }

  @override
  void loadOrders() {
    cubit.loadOrders();
  }

  @override
  Future<void> refreshOrders() async {
    return await cubit.loadOrders();
  }

  @override
  void onOrderTapped(BuildContext context, OrderModel order) {
    context.pushNamed(OrderDetailScreen.route, extra: order);
  }

  @override
  void navigateToBrowseCards(BuildContext context) {
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
