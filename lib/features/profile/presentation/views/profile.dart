part of '../controllers/profile.dart';

class ProfileView extends StatelessWidget implements ProfileViewContract {
  const ProfileView({super.key, required this.controller});

  final ProfileControllerContract controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: controller.authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Profile')),
          body: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final name = state is AuthAuthenticated
                  ? state.user.firstName ?? 'User'
                  : 'User';
              final email = state is AuthAuthenticated
                  ? state.user.email ?? ''
                  : '';

              return SingleChildScrollView(
                padding: REdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 90.w,
                            height: 90.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : 'U',
                                style: AppTextStyles.heading1.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 36.sp,
                                ),
                              ),
                            ),
                          ),
                          16.verticalSpace,
                          Text(name, style: AppTextStyles.heading2),
                          6.verticalSpace,
                          Text(email, style: AppTextStyles.body2),
                        ],
                      ),
                    ),
                    32.verticalSpace,

                    // Quick nav tiles
                    _NavTile(
                      icon: Icons.receipt_long_outlined,
                      label: 'My Orders',
                      onTap: () => controller.navigateToOrders(context),
                    ),
                    _NavTile(
                      icon: Icons.confirmation_number_outlined,
                      label: 'My Vouchers',
                      onTap: () => controller.navigateToVouchers(context),
                    ),
                    _NavTile(
                      icon: Icons.shopping_cart_outlined,
                      label: 'My Cart',
                      onTap: () => controller.navigateToCart(context),
                    ),
                    24.verticalSpace,

                    // Logout
                    AppButton(
                      label: 'Log Out',
                      backgroundColor: AppColors.error,
                      onPressed: () =>
                          controller.confirmLogout(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.sp),
        ),
        title: Text(
          label,
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
          color: AppColors.textSecondary,
        ),
        contentPadding: REdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
