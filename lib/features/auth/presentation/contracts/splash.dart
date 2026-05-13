part of '../controllers/splash.dart';

abstract class SplashControllerContract {
  void resolveAuthState();
}

abstract class SplashViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {}
