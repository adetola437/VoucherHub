part of '../controllers/checkout_result.dart';

class CheckoutResultView extends StatelessWidget
    implements CheckoutResultViewContract {
  const CheckoutResultView({super.key, required this.controller});

  final CheckoutResultControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final color = controller.statusColor;
    final icon = controller.statusIcon;

    // Pick the best available order ID to display
    final displayOrderId = controller.result.suregiftsOrderId ??
        controller.result.orderId;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const Spacer(),
              // Status Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64.sp, color: color),
              ),
              32.verticalSpace,
              // Title
              Text(
                controller.statusTitle,
                style: AppTextStyles.heading1.copyWith(color: color),
              ),
              16.verticalSpace,
              // Subtitle
              Text(
                controller.statusSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              // Order ID Card — only shown when we have an ID to display
              if (displayOrderId != null) ...[
                24.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: REdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Order ID',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        displayOrderId,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Voucher Preview Card
              if (controller.result.vouchers != null &&
                  controller.result.vouchers!.isNotEmpty) ...[
                24.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: REdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: REdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.card_giftcard_outlined,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.result.vouchers!.length} Voucher${controller.result.vouchers!.length > 1 ? 's' : ''} Ready',
                              style: AppTextStyles.body2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              'Available in your voucher wallet',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              // Actions
              _buildActions(context),
              12.verticalSpace,
              TextButton(
                onPressed: () => controller.navigateToCatalogue(context),
                child: Text(
                  'Back to Catalogue',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (controller.isSuccess || controller.isPending) {
      return Column(
        children: [
          AppButton(
            label: 'View My Vouchers',
            onPressed: () => controller.navigateToVouchers(context),
          ),
          12.verticalSpace,
          AppButton(
            label: 'View Orders',
            onPressed: () => controller.navigateToOrders(context),
          ),
        ],
      );
    }

    return AppButton(
      label: 'Try Again',
      onPressed: () => controller.navigateToCart(context),
    );
  }
}