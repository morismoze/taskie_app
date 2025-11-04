import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void showError({
    required BuildContext context,
    required String message,
    AppSnackBarActionData? actionData,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _createSnackBar(
        message: message,
        color: _AppSnackbarStyle.errorColor,
        backgroundColor: _AppSnackbarStyle.errorBackgroundColor,
        iconData: FontAwesomeIcons.solidCircleXmark,
        actionData: actionData,
        duration: duration,
      ),
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    AppSnackBarActionData? actionData,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _createSnackBar(
        message: message,
        color: _AppSnackbarStyle.successColor,
        backgroundColor: _AppSnackbarStyle.successBackgroundColor,
        iconData: FontAwesomeIcons.solidCircleCheck,
        actionData: actionData,
        duration: duration,
      ),
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    AppSnackBarActionData? actionData,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _createSnackBar(
        message: message,
        color: _AppSnackbarStyle.infoColor,
        backgroundColor: _AppSnackbarStyle.infoBackgroundColor,
        iconData: FontAwesomeIcons.circleInfo,
        actionData: actionData,
        duration: duration,
      ),
    );
  }

  static SnackBar _createSnackBar({
    required String message,
    required Color color,
    required Color backgroundColor,
    required IconData iconData,
    AppSnackBarActionData? actionData,
    Duration? duration,
  }) {
    SnackBarAction? snackBarAction;

    if (actionData != null) {
      snackBarAction = SnackBarAction(
        label: actionData.label,
        onPressed: actionData.onPressed,
        textColor: color,
      );
    }

    return SnackBar(
      behavior: SnackBarBehavior.floating,
      action: snackBarAction,
      actionOverflowThreshold: 1,
      duration: duration ?? const Duration(seconds: 4),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 0.5),
      ),
      elevation: 0,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(iconData, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: _AppSnackbarStyle.textColor,
                  fontWeight: _AppSnackbarStyle.textWeight,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppSnackBarActionData {
  final String label;
  final VoidCallback onPressed;

  AppSnackBarActionData({required this.label, required this.onPressed});
}

abstract final class _AppSnackbarStyle {
  static const successColor = Color(0xFF52DC69);
  static const successBackgroundColor = Color(0xFFF1F9F4);
  static const errorColor = Color(0xFFFF585B);
  static const errorBackgroundColor = Color(0xFFFCEFEA);
  static const infoColor = Color(0xFF3387E8);
  static const infoBackgroundColor = Color(0xFFE7EEFA);
  static const textColor = AppColors.black1;

  static const textWeight = FontWeight.w600;
}
