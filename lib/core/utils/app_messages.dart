import 'package:flutter/material.dart';
import '../../config/di/app_initializer.dart';
import '../theme/app_colors.dart';

class AppMessages {
  AppMessages._();

  /// Global key to access ScaffoldMessenger without context


  /// Global key to access Navigator without context


  /// Shows a success snackbar
  static void showSuccess({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final state = messengerKey.currentState;
    if (state == null) return;

    state.clearSnackBars();
    state.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  /// Shows an error snackbar
  static void showError({required String message}) {
    final state = messengerKey.currentState;
    if (state == null) return;

    state.clearSnackBars();
    state.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}