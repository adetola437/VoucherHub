part of '../controllers/splash.dart';

class SplashView extends StatelessWidget implements SplashViewContract {
  const SplashView({super.key, required this.controller});

  final SplashControllerContract controller;

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_SplashScreenState>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FadeTransition(
        opacity: state?._bgOpacity ?? AlwaysStoppedAnimation(1.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Decorative background blobs
            Positioned(
              top: -80.r,
              right: -60.r,
              child: _Blob(size: 280.r, color: Colors.white.withOpacity(0.07)),
            ),
            Positioned(
              bottom: -60.r,
              left: -80.r,
              child: _Blob(size: 320.r, color: Colors.white.withOpacity(0.05)),
            ),
            Positioned(
              top: 180.h,
              left: -40.r,
              child: _Blob(size: 160.r, color: Colors.white.withOpacity(0.06)),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  ScaleTransition(
                    scale: state?._logoScale ?? AlwaysStoppedAnimation(1.0),
                    child: FadeTransition(
                      opacity: state?._logoOpacity ?? AlwaysStoppedAnimation(1.0),
                      child: _LogoBadge(),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // App name + tagline
                  SlideTransition(
                    position:
                        state?._textSlide ?? AlwaysStoppedAnimation(Offset.zero),
                    child: FadeTransition(
                      opacity: state?._textOpacity ?? AlwaysStoppedAnimation(1.0),
                      child: Column(
                        children: [
                          Text(
                            'VoucherHub',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Your gateway to gift vouchers',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white.withOpacity(0.75),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom loader
            Positioned(
              bottom: 52.h,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: state?._textOpacity ?? AlwaysStoppedAnimation(1.0),
                child: const _PulsingDots(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Logo Badge ───────────────────────────────────────────────────────────────
class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.r,
      height: 110.r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.card_giftcard_rounded,
          size: 58.r,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ─── Decorative blob ──────────────────────────────────────────────────────────
class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ─── Animated loading dots ────────────────────────────────────────────────────
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            // Stagger each dot by 0.2
            final t = (_ctrl.value + i * 0.2) % 1.0;
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
