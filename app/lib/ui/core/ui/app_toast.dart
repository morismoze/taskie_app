import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../theme/colors.dart';
import '../utils/extensions.dart';

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
    required String title,
    bool persistent = false,
    String? description,
    Duration? duration,
    void Function(ToastificationItem)? onTap,
    void Function(ToastificationItem)? onDismissed,
    void Function(ToastificationItem)? onCloseButtonTap,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      primaryColor: AppColors.blue1,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.black1,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      description: description?.toStyledText(
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      autoCloseDuration: persistent
          ? null
          : (duration ?? const Duration(seconds: 4)),
      callbacks: ToastificationCallbacks(
        onTap: onTap,
        onDismissed: onDismissed,
        onCloseButtonTap: onCloseButtonTap,
      ),
    );
  }
}
