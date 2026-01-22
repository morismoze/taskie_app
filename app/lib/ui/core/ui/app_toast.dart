import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../theme/colors.dart';

class AppToast {
  AppToast._();

  static void showError({
    required BuildContext context,
    required String message,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      primaryColor: AppColors.red1,
      title: Text(
        message,
        style: const TextStyle(
          color: AppColors.black1,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      primaryColor: AppColors.green2,
      title: Text(
        message,
        style: const TextStyle(
          color: AppColors.black1,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration? duration,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      primaryColor: AppColors.blue1,
      title: Text(
        message,
        style: const TextStyle(
          color: AppColors.black1,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}
