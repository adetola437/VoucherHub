part of '../controllers/orders.dart';

class OrdersView extends StatelessWidget implements OrdersViewContract {
  const OrdersView({super.key, required this.controller});

  final OrdersControllerContract controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: controller.cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('My Orders')),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return _OrdersShimmer();
            }
            if (state is OrdersError) {
              return AppError(
                message: state.message,
                onRetry: () => controller.loadOrders(),
              );
            }
            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return AppEmpty(
                  title: 'No orders yet',
                  subtitle: 'Your completed orders will appear here',
                  icon: Icons.receipt_long_outlined,
                  onAction: () =>
                      controller.navigateToBrowseCards(context),
                  actionLabel: 'Browse Cards',
                );
              }
              return RefreshIndicator(
                onRefresh: () => controller.refreshOrders(),
                child: ListView.builder(
                  padding: REdgeInsets.all(16),
                  itemCount: state.orders.length,
                  itemBuilder: (_, i) => _OrderCard(
                    order: state.orders[i],
                    onTap: () => controller.onOrderTapped(
                      context,
                      state.orders[i],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: REdgeInsets.only(bottom: 12),
        padding: REdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: AppTextStyles.body1
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                if (order.status != null) StatusChip(status: order.status!),
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                _InfoPill(
                  icon: Icons.calendar_today_outlined,
                  label: DateFormatter.format(order.createdAt),
                ),
                12.horizontalSpace,
                if (order.voucherCount != null)
                  _InfoPill(
                    icon: Icons.confirmation_number_outlined,
                    label: '${order.voucherCount} voucher(s)',
                  ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTextStyles.body2),
                Text(
                  CurrencyFormatter.formatAmount(
                      order.totalAmount ?? 0, order.currency),
                  style: AppTextStyles.price.copyWith(fontSize: 16.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.textSecondary),
        4.horizontalSpace,
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _OrdersShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: REdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          height: 110.h,
          margin: REdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}
