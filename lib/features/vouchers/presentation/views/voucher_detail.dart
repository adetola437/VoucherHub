part of '../controllers/voucher_detail.dart';

class VoucherDetailView extends StatelessWidget implements VoucherDetailViewContract {
  const VoucherDetailView({super.key, required this.controller});

  final VoucherDetailControllerContract controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: controller.cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Voucher Details')),
        body: BlocBuilder<VouchersCubit, VouchersState>(
          builder: (context, state) {
            if (state is VoucherDetailLoading) {
              return const AppLoading(message: 'Loading voucher...');
            }
            if (state is VouchersError) {
              return AppError(
                message: state.message,
                onRetry: () => controller.loadVoucherDetail(),
              );
            }
            if (state is VoucherDetailLoaded) {
              return _VoucherDetailBody(
                voucher: state.voucher,
                operations: state.operations,
                controller: controller,
              );
            }
            return const AppLoading();
          },
        ),
      ),
    );
  }
}

class _VoucherDetailBody extends StatelessWidget {
  final VoucherModel voucher;
  final List<VoucherOperationModel> operations;
  final VoucherDetailControllerContract controller;

  const _VoucherDetailBody({
    required this.voucher,
    required this.operations,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: REdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          _HeaderCard(voucher: voucher),
          24.verticalSpace,

          // Voucher Code Section
          if (voucher.voucherCode != null) ...[
            Text('Voucher Code', style: AppTextStyles.heading3),
            12.verticalSpace,
            _CodeCard(
              voucher: voucher,
              controller: controller,
            ),
            24.verticalSpace,
          ],

          // ── Redemption URL ─────────────────────────────────────────────────
          if (voucher.redemptionUrl != null) ...[
            Text('Redemption', style: AppTextStyles.heading3),
            12.verticalSpace,
            _RedemptionUrlCard(url: voucher.redemptionUrl!),
            24.verticalSpace,
          ],

          // Validity
          Text('Validity', style: AppTextStyles.heading3),
          12.verticalSpace,
          _InfoCard(children: [
            if (voucher.createdAtUtc != null)
              _InfoRow(
                  'Created Date',
                  DateFormatter.formatWithTime(voucher.createdAtUtc)),
            _InfoRow(
                'Expiry Date',
                voucher.expiryDate != null
                    ? DateFormatter.format(voucher.expiryDate)
                    : 'No expiry'),
          ]),
          24.verticalSpace,

          // Operations history
          if (operations.isNotEmpty) ...[
            Text('Activity History', style: AppTextStyles.heading3),
            12.verticalSpace,
            _OperationsTimeline(operations: operations),
            24.verticalSpace,
          ],
        ],
      ),
    );
  }
}

// ── Redemption URL card ────────────────────────────────────────────────────────
class _RedemptionUrlCard extends StatelessWidget {
  final String url;
  const _RedemptionUrlCard({required this.url});

  Future<void> _launch() async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primaryLight, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.open_in_browser_outlined,
              size: 20.sp, color: AppColors.primary),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Redeem Online', style: AppTextStyles.body2
                    .copyWith(fontWeight: FontWeight.w600)),
                4.verticalSpace,
                Text(
                  url,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          ElevatedButton(
            onPressed: _launch,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: REdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text('Open',
                style: AppTextStyles.label.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final VoucherModel voucher;
  const _HeaderCard({required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppNetworkImage(
                imageUrl: voucher.productImageUrl,
                width: 56.w,
                height: 56.w,
                borderRadius: BorderRadius.circular(10.r),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.productName ?? 'Gift Card',
                      style: AppTextStyles.heading3
                          .copyWith(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // ── Status badge ───────────────────────────────────────
                    if (voucher.status != null) ...[
                      6.verticalSpace,
                      StatusChip(status: voucher.status!),
                    ],
                  ],
                ),
              ),
            ],
          ),
          20.verticalSpace,
          if (voucher.amount != null)
            Text(
              CurrencyFormatter.formatAmount(
                  voucher.amount!, voucher.currency ?? 'NGN'),
              style: AppTextStyles.heading1
                  .copyWith(color: Colors.white, fontSize: 32.sp),
            ),
        ],
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  final VoucherModel voucher;
  final VoucherDetailControllerContract controller;

  const _CodeCard({
    required this.voucher,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primaryLight, width: 2),
      ),
      child: Column(
        children: [
          if (voucher.voucherCode != null)
            _CopyRow(
              label: 'Voucher Code',
              value: voucher.voucherCode!,
              icon: Icons.confirmation_number_outlined,
              isHighlighted: true,
              onCopy: () => controller.copyToClipboard(
                  context, voucher.voucherCode!, 'Voucher code'),
            ),
          if (voucher.pin != null) ...[
            Divider(color: AppColors.divider, height: 20),
            _CopyRow(
              label: 'PIN',
              value: voucher.pin!,
              icon: Icons.lock_outline,
              onCopy: () =>
                  controller.copyToClipboard(context, voucher.pin!, 'PIN'),
            ),
          ],
          if (voucher.serialNumber != null) ...[
            Divider(color: AppColors.divider, height: 20),
            _CopyRow(
              label: 'Serial Number',
              value: voucher.serialNumber!,
              icon: Icons.tag,
              onCopy: () => controller.copyToClipboard(
                  context, voucher.serialNumber!, 'Serial number'),
            ),
          ],
          if (voucher.expiryDate != null) ...[
            Divider(color: AppColors.divider, height: 20),
            Row(
              children: [
                Icon(Icons.event_outlined,
                    size: 18.sp, color: AppColors.textSecondary),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expiry Date', style: AppTextStyles.caption),
                    4.verticalSpace,
                    Text(DateFormatter.format(voucher.expiryDate),
                        style: AppTextStyles.body1
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isHighlighted;
  final VoidCallback onCopy;

  const _CopyRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onCopy,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 18.sp,
            color: isHighlighted ? AppColors.primary : AppColors.textSecondary),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              4.verticalSpace,
              Text(
                value,
                style: isHighlighted
                    ? AppTextStyles.heading3
                        .copyWith(color: AppColors.primary, letterSpacing: 2)
                    : AppTextStyles.body1
                        .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onCopy,
          icon: Icon(Icons.copy, size: 18.sp, color: AppColors.primary),
          tooltip: 'Copy $label',
        ),
      ],
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
        children: children
            .expand((w) => [w, Divider(color: AppColors.divider, height: 16)])
            .take(children.length * 2 - 1)
            .toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body2),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _OperationsTimeline extends StatelessWidget {
  final List<VoucherOperationModel> operations;
  const _OperationsTimeline({required this.operations});

  IconData _iconForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'purchase':
      case 'purchased':
        return Icons.shopping_bag_outlined;
      case 'delivery':
      case 'delivered':
        return Icons.check_circle_outline;
      case 'failed':
        return Icons.error_outline;
      default:
        return Icons.history;
    }
  }

  Color _colorForStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'success':
      case 'delivered':
      case 'purchase_successful':
        return AppColors.success;
      case 'failed':
      case 'purchase_failed':
        return AppColors.error;
      case 'pending':
      case 'processing':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: operations.length,
        separatorBuilder: (_, __) =>
            Divider(color: AppColors.divider, height: 1),
        itemBuilder: (_, i) {
          final op = operations[i];
          final color = _colorForStatus(op.status ?? op.type);
          return Padding(
            padding: REdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_iconForType(op.type),
                      size: 18.sp, color: color),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        op.type?.replaceAll('_', ' ').toUpperCase() ??
                            'OPERATION',
                        style: AppTextStyles.body2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (op.description != null) ...[
                        4.verticalSpace,
                        Text(op.description!,
                            style: AppTextStyles.caption),
                      ],
                      4.verticalSpace,
                      Text(
                          DateFormatter.formatWithTime(op.createdAt),
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
                if (op.status != null)
                  StatusChip(status: op.status!),
              ],
            ),
          );
        },
      ),
    );
  }
}