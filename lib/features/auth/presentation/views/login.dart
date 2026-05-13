part of '../controllers/login.dart';

class LoginView extends StatelessWidget implements LoginViewContract {
  const LoginView({super.key, required this.controller, required this.cubit});

  final LoginControllerContract controller;
  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/products');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: REdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    80.verticalSpace,
                    // Logo / Brand
                    Center(
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(Icons.card_giftcard,
                            size: 44.sp, color: Colors.white),
                      ),
                    ),
                    24.verticalSpace,
                    Center(
                      child: Text('VoucherHub',
                          style: AppTextStyles.heading1
                              .copyWith(color: AppColors.primary)),
                    ),
                    8.verticalSpace,
                    Center(
                      child: Text('Your gift card marketplace',
                          style: AppTextStyles.body2),
                    ),
                    48.verticalSpace,
                    Text('Welcome back', style: AppTextStyles.heading2),
                    8.verticalSpace,
                    Text('Sign in to continue', style: AppTextStyles.body2),
                    28.verticalSpace,
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: controller.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.email_outlined),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    20.verticalSpace,
                    ValueListenableBuilder<bool>(
                      valueListenable: controller.obscurePassword,
                      builder: (context, obscureText, _) => AppTextField(
                        label: 'Password',
                        hint: 'Enter your password',
                        controller: controller.passwordCtrl,
                        obscureText: obscureText,
                        prefix: const Icon(Icons.lock_outlined),
                        suffix: IconButton(
                          icon: Icon(obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () {
                            controller.obscurePassword.value =
                                !controller.obscurePassword.value;
                          },
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 6) return 'Password too short';
                          return null;
                        },
                      ),
                    ),
                    32.verticalSpace,
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) => AppButton(
                        label: 'Sign In',
                        isLoading: authState is AuthLoading,
                        onPressed: authState is AuthLoading ? null : controller.submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
