part of '../controllers/cart.dart';

class CartView extends StatelessWidget implements CartViewContract {
  const CartView({super.key, required this.controller, required this.cubit});

  final CartControllerContract controller;
  final CartCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Cart'),
          actions: [
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                final cart = state is CartLoaded
                    ? state.cart
                    : state is CartItemAdded
                        ? (state as CartItemAdded).cart
                        : null;
                if (cart != null && !cart.isEmpty) {
                  return TextButton(
                    onPressed: () => controller.clearCart(context),
                    child: const Text('Clear',
                        style: TextStyle(color: Colors.white)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            // Per-item errors show a SnackBar without replacing the screen
            if (state is CartLoaded && state.lastError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.lastError!),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const AppLoading(message: 'Loading cart...');
            }
            if (state is CartError) {
              return AppError(
                message: state.message,
                onRetry: () => controller.loadCart(),
              );
            }
            if (state is CartLoaded || state is CartItemAdded) {
              final cart = state is CartLoaded
                  ? state.cart
                  : (state as CartItemAdded).cart;
              if (cart.isEmpty) {
                return AppEmpty(
                  title: 'Your cart is empty',
                  subtitle: 'Browse gift cards and add them here',
                  icon: Icons.shopping_cart_outlined,
                  onAction: () => controller.navigateToCatalogue(context),
                  actionLabel: 'Browse',
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: REdgeInsets.all(16),
                      itemCount: cart.items.length,
                      itemBuilder: (_, i) {
                        final item = cart.items[i];
                        final isBusy = state is CartLoaded &&
                            (state as CartLoaded).isBusy(item.id);
                        return _CartItemCard(
                          item: item,
                          controller: controller,
                          isBusy: isBusy,
                        );
                      },
                    ),
                  ),
                  _CartSummary(cart: cart, controller: controller),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final CartControllerContract controller;
  final bool isBusy;

  const _CartItemCard({
    required this.item,
    required this.controller,
    required this.isBusy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.only(bottom: 12),
      padding: REdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          AppNetworkImage(
            imageUrl: item.productImage,
            width: 64.w,
            height: 64.w,
            borderRadius: BorderRadius.circular(10.r),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName ?? 'Gift Card',
                    style: AppTextStyles.body1
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                6.verticalSpace,
                Text(
                    CurrencyFormatter.formatAmount(item.amount, item.currency),
                    style: AppTextStyles.price.copyWith(fontSize: 14.sp)),
                8.verticalSpace,
                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: isBusy || item.quantity <= 1
                          ? null
                          : () => controller.updateItem(
                              item.id, item.quantity - 1),
                    ),
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 12),
                      child: isBusy
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : Text('${item.quantity}',
                              style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.w600)),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: isBusy
                          ? null
                          : () => controller.updateItem(
                              item.id, item.quantity + 1),
                    ),
                    const Spacer(),
                    Text(
                        CurrencyFormatter.formatAmount(
                            item.totalPrice, item.currency),
                        style: AppTextStyles.body2
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: isBusy ? null : () => controller.removeItem(item.id),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: REdgeInsets.all(4),
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.primaryLight : AppColors.divider,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(icon,
            size: 16.sp,
            color: onTap != null
                ? AppColors.primary
                : AppColors.textSecondary),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartModel cart;
  final CartControllerContract controller;
  const _CartSummary({required this.cart, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: AppTextStyles.body2),
              Text(
                CurrencyFormatter.formatAmount(
                    cart.calculatedTotal, cart.currency ?? 'NGN'),
                style: AppTextStyles.body1
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          12.verticalSpace,
          AppButton(
            label: 'Proceed to Checkout',
            onPressed: () => controller.checkout(context),
          ),
        ],
      ),
    );
  }
}