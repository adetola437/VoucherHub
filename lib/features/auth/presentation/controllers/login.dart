import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

part '../contracts/login.dart';
part '../views/login.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    implements LoginControllerContract {
  late final LoginViewContract view;
  late AuthCubit cubit;

  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  final TextEditingController emailCtrl =
      TextEditingController(text: 'test@mail.com');
  @override
  final TextEditingController passwordCtrl =
      TextEditingController(text: 'Password1@');
  @override
  late ValueNotifier<bool> obscurePassword;

  @override
  void initState() {
    super.initState();
    cubit = sl<AuthCubit>();
    obscurePassword = ValueNotifier<bool>(true);
    view = LoginView(controller: this, cubit: cubit);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    obscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return view.build(context);
  }

  @override
  void submit() {
    debugPrint('Submit called');
    if (formKey.currentState?.validate() ?? false) {
      debugPrint('Form validation passed, calling login');
      cubit.login(emailCtrl.text.trim(), passwordCtrl.text);
    } else {
      debugPrint('Form validation failed');
    }
  }
}
