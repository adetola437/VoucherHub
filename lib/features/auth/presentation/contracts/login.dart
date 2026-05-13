part of '../controllers/login.dart';

abstract class LoginControllerContract {
  void submit();
  GlobalKey<FormState> get formKey;
  TextEditingController get emailCtrl;
  TextEditingController get passwordCtrl;
  ValueNotifier<bool> get obscurePassword;
}

abstract class LoginViewContract extends BaseViewContract {
  Widget build(BuildContext context);
}

abstract class BaseViewContract {}
