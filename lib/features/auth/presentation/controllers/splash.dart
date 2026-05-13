import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voucher_hub/features/products/presentation/controllers/product_catalogue.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

part '../contracts/splash.dart';
part '../views/splash.dart';

class SplashScreen extends StatefulWidget {
  static const String route = 'splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin
    implements SplashControllerContract {
  late final SplashViewContract view;

  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _bgController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _bgOpacity;

  @override
  void initState() {
    super.initState();
    view = SplashView(controller: this);
    _setupAnimations();
    _startSplashFlow();
  }

  void _setupAnimations() {
    // Background fade in
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bgOpacity = CurvedAnimation(parent: _bgController, curve: Curves.easeIn);

    // Logo scale + fade
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text slide up + fade
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
  }

  Future<void> _startSplashFlow() async {
    // Run animations in sequence
    _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Wait for auth check + minimum display time
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1800)),
      resolveAuthState(),
    ]);
  }

  @override
  Future<void> resolveAuthState() async {
    final authCubit = sl<AuthCubit>();

    // Wait until AuthCubit is no longer in initial state
    // (it runs _checkSavedSession in its constructor)
    while (authCubit.state is AuthInitial) {
      await Future.delayed(const Duration(seconds: 3));
    }

    if (!mounted) return;

    if (authCubit.state is AuthAuthenticated) {
      context.goNamed(ProductCatalogueScreen.route);
    } else {
      context.goNamed('login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return view.build(context);
  }
}
