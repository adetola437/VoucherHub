part of '../controllers/order_detail.dart';

class OrderDetailView extends StatelessWidget implements OrderDetailViewContract {
  const OrderDetailView({super.key, required this.controller});

  final OrderDetailControllerContract controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: controller.cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Order #${controller.order.id}'),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrderDetailLoading) {
              return const AppLoading(message: 'Loading order details...');
            }
            if (state is OrdersError) {
              return AppError(
                message: state.message,
                onRetry: () => controller.loadOrderDetail(),
              );
            }
            final order = state is OrderDetailLoaded
                ? state.order
                : controller.order;
            return _OrderDetailBody(
              order: order,
              controller: controller,
            );
          },
        ),
      ),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  final OrderModel order;
  final OrderDetailControllerContract controller;

  const _OrderDetailBody({
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: REdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _StatusCard(order: order),
          20.verticalSpace,

          // Order info
          Text('Order Information', style: AppTextStyles.heading3),
          12.verticalSpace,
          _InfoCard(children: [
            _InfoRow('Order ID', '#${order.id}'),
            _InfoRow('Date', DateFormatter.formatWithTime(order.createdAt)),
            _InfoRow('Status', order.status ?? 'N/A'),
            _InfoRow('Currency', order.currency ?? 'NGN'),
            if (order.voucherCount != null)
              _InfoRow('Vouchers', '${order.voucherCount}'),
          ]),
          20.verticalSpace,

          // Items
          if (order.items.isNotEmpty) ...[
            Text('Items', style: AppTextStyles.heading3),
            12.verticalSpace,
            ...order.items.map((item) => _ItemCard(item: item)),
            20.verticalSpace,
          ],

          // Total
          _InfoCard(children: [
            _InfoRow(
              'Total Amount',
              CurrencyFormatter.formatAmount(
                  order.totalAmount ?? 0, order.currency),
              isBold: true,
            ),
          ]),
          20.verticalSpace,

          // View Vouchers CTA
          AppButton(
            label: 'View Vouchers',
            onPressed: () => controller.navigateToVouchers(context),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final OrderModel order;
  const _StatusCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (order.status != null) StatusChip(status: order.status!),
          12.verticalSpace,
          Text(
            CurrencyFormatter.formatAmount(
                order.totalAmount ?? 0, order.currency),
            style: AppTextStyles.heading1
                .copyWith(color: AppColors.primary),
          ),
          4.verticalSpace,
          Text('Total Amount', style: AppTextStyles.body2),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _InfoRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body2),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: isBold
                  ? AppTextStyles.body1
                      .copyWith(fontWeight: FontWeight.w700)
                  : AppTextStyles.body1
                      .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final OrderItemModel item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.only(bottom: 10),
      padding: REdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          AppNetworkImage(
            imageUrl: item.productImage,
            width: 52.w,
            height: 52.w,
            borderRadius: BorderRadius.circular(8.r),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName ?? 'Gift Card',
                    style: AppTextStyles.body2
                        .copyWith(fontWeight: FontWeight.w600)),
                4.verticalSpace,
                Text(
                    '${CurrencyFormatter.formatAmount(item.amount ?? 0, item.currency)} × ${item.quantity}',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.formatAmount(
                (item.amount ?? 0) * (item.quantity ?? 1), item.currency),
            style:
                AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
