import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/cubit/auth_state.dart';

part '../contracts/profile.dart';
part '../views/profile.dart';

class ProfileScreen extends StatefulWidget {
  static const route = 'profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    implements ProfileControllerContract {
  late final ProfileViewContract view;

  @override
  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = sl<AuthCubit>();
    view = ProfileView(controller: this);
  }

  @override
  void logout() {
    authCubit.logout();
  }

  @override
  void confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              logout();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void navigateToOrders(BuildContext context) {
    context.push('/orders');
  }

  @override
  void navigateToVouchers(BuildContext context) {
    context.push('/vouchers');
  }

  @override
  void navigateToCart(BuildContext context) {
    context.push('/cart');
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
