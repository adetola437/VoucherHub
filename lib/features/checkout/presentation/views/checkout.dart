part of '../controllers/checkout.dart';

class CheckoutView extends StatelessWidget implements CheckoutViewContract {
  const CheckoutView({super.key, required this.controller});

  final CheckoutControllerContract controller;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: GetIt.I<CartCubit>()),
        BlocProvider.value(value: GetIt.I<CheckoutCubit>()),
      ],
      child: BlocListener<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            controller.navigateToResult(context, state.result, state.result);
          }
          if (state is CheckoutFailure || state is CheckoutError) {
            final msg = state is CheckoutFailure
                ? state.message
                : (state as CheckoutError).message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: AppColors.error),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Checkout')),
          body: SingleChildScrollView(
            padding: REdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Items
                Text('Order Summary', style: AppTextStyles.heading3),
                16.verticalSpace,
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      return _CartItemsList(cart: state.cart);
                    }
                    return const AppLoading();
                  },
                ),
                24.verticalSpace,
                // Total Breakdown
                Text('Price Breakdown', style: AppTextStyles.heading3),
                16.verticalSpace,
                BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (context, state) {
                    if (state is CheckoutCalculating) {
                      return _TotalShimmer();
                    }
                    if (state is CheckoutTotalLoaded) {
                      return _TotalBreakdown(total: state.total);
                    }
                    if (state is CheckoutError) {
                      return AppError(
                        message: state.message,
                        onRetry: () => controller.calculateTotal(),
                      );
                    }
                    // For processing/success states, keep showing last total
                    return _TotalShimmer();
                  },
                ),
                32.verticalSpace,
                // Payment note
                Container(
                  padding: REdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppColors.primary, size: 20),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          'Payment is simulated. No real charge will be made.',
                          style: AppTextStyles.body2
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                32.verticalSpace,
                BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (context, state) {
                    final isLoading = state is CheckoutProcessing;
                    final isReady = state is CheckoutTotalLoaded;
                    return AppButton(
                      label: 'Place Order',
                      isLoading: isLoading,
                      onPressed: isReady ? () => controller.placeOrder() : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CartItemsList extends StatelessWidget {
  final CartModel cart;
  const _CartItemsList({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          ...cart.items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      AppNetworkImage(
                        imageUrl: item.productImage,
                        width: 48.w,
                        height: 48.w,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName ?? 'Gift Card',
                                style: AppTextStyles.body2
                                    .copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            4.verticalSpace,
                            Text(
                                '${CurrencyFormatter.formatAmount(item.amount, item.currency)} × ${item.quantity}',
                                style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Text(
                          CurrencyFormatter.formatAmount(
                              item.totalPrice, item.currency),
                          style: AppTextStyles.body2
                              .copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                if (i < cart.items.length - 1)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TotalBreakdown extends StatelessWidget {
  final CheckoutTotalModel total;
  const _TotalBreakdown({required this.total});

  @override
  Widget build(BuildContext context) {
    final currency = total.currency ?? 'NGN';
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          if (total.subtotal != null)
            _Row(
                label: 'Subtotal',
                value: CurrencyFormatter.formatAmount(total.subtotal!, currency)),
          if (total.fees != null && total.fees! > 0)
            _Row(
                label: 'Fees',
                value: CurrencyFormatter.formatAmount(total.fees!, currency)),
          const Divider(height: 20, color: AppColors.divider),
          _Row(
            label: 'Total',
            value: total.total != null
                ? CurrencyFormatter.formatAmount(total.total!, currency)
                : 'N/A',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const _Row({required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isTotal
                  ? AppTextStyles.body1.copyWith(fontWeight: FontWeight.w700)
                  : AppTextStyles.body2),
          Text(value,
              style: isTotal
                  ? AppTextStyles.price
                  : AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TotalShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: const Center(child: AppLoading()),
    );
  }
}