import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../cubit/vouchers_cubit.dart';
import '../../data/models/voucher_model.dart';

part '../contracts/voucher_detail.dart';
part '../views/voucher_detail.dart';

class VoucherDetailScreen extends StatefulWidget {
  static const route = 'voucher-detail';
  final VoucherModel voucher;
  const VoucherDetailScreen({super.key, required this.voucher});

  @override
  State<VoucherDetailScreen> createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen>
    implements VoucherDetailControllerContract {
  late final VoucherDetailViewContract view;

  @override
  late VouchersCubit cubit;

  @override
  VoucherModel get voucher => widget.voucher;

  @override
  void initState() {
    super.initState();
    cubit = sl<VouchersCubit>();
    view = VoucherDetailView(controller: this);
    loadVoucherDetail();
  }

  @override
  void loadVoucherDetail() {
    if (voucher.id != null) {
      cubit.loadVoucherDetail(voucher.id!);
    }
  }

  @override
  void copyToClipboard(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Future<void> launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await url_launcher.canLaunchUrl(uri)) {
      await url_launcher.launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return view.build(context);
  }

  @override
  void dispose() {
    GetIt.I.get<VouchersCubit>().loadVouchers();
    super.dispose();
  }
}
