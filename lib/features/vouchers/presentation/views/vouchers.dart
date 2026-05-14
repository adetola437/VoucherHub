part of '../controllers/vouchers.dart';

class VouchersView extends StatelessWidget implements VouchersViewContract {
  const VouchersView({super.key, required this.controller});

  final VouchersControllerContract controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I.get<VouchersCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('My Vouchers')),
        body: BlocBuilder<VouchersCubit, VouchersState>(
          builder: (context, state) {
            if (state is VouchersLoading) {
              return _VouchersShimmer();
            }
            if (state is VouchersError) {
              return AppError(
                message: state.message,
                onRetry: () => controller.loadVouchers(),
              );
            }
            if (state is VouchersLoaded) {
              if (state.vouchers.isEmpty) {
                return AppEmpty(
                  title: 'No vouchers yet',
                  subtitle: 'Purchase gift cards to see your vouchers here',
                  icon: Icons.confirmation_number_outlined,
                  onAction: () => controller.navigateToProducts(),
                  actionLabel: 'Shop Now',
                );
              }
              return RefreshIndicator(
                onRefresh: () => controller.refreshVouchers(),
                child: ListView.builder(
                  padding: REdgeInsets.all(16),
                  itemCount: state.vouchers.length,
                  itemBuilder: (_, i) => _VoucherCard(
                    voucher: state.vouchers[i],
                    onTap: () =>
                        controller.onVoucherTapped(state.vouchers[i]),
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

  @override
  void showErrorDialog(String message) {
    // Show error dialog implementation
  }
}

class _VoucherCard extends StatelessWidget {
  final VoucherModel voucher;
  final VoidCallback onTap;

  const _VoucherCard({
    required this.voucher,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: REdgeInsets.only(bottom: 12),
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
            // Top section with image + info
            Padding(
              padding: REdgeInsets.all(14),
              child: Row(
                children: [
                  AppNetworkImage(
                    imageUrl: voucher.productImageUrl,
                    width: 60.w,
                    height: 60.w,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucher.productName ?? 'Gift Card',
                          style: AppTextStyles.body1
                              .copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        6.verticalSpace,
                        if (voucher.amount != null)
                          Text(
                            CurrencyFormatter.formatAmount(
                                voucher.amount!, voucher.currency ?? 'NGN'),
                            style: AppTextStyles.price
                                .copyWith(fontSize: 15.sp),
                          ),
                        4.verticalSpace,
                        if (voucher.createdAtUtc != null)
                          Text(
                            DateFormatter.format(voucher.createdAtUtc),
                            style: AppTextStyles.caption,
                          ),
                      ],
                    ),
                  ),
                  // ── Status chip ────────────────────────────────────────────
                  if (voucher.status != null)
                    StatusChip(status: voucher.status!),
                ],
              ),
            ),
            // Bottom bar
            Container(
              padding: REdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 12.sp,
                          color: AppColors.textSecondary),
                      4.horizontalSpace,
                      Text(
                        voucher.expiryDate != null
                            ? 'Expires: ${DateFormatter.format(voucher.expiryDate)}'
                            : 'No expiry',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('View Details',
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                      4.horizontalSpace,
                      Icon(Icons.arrow_forward_ios,
                          size: 10.sp, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VouchersShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: REdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          height: 120.h,
          margin: REdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}