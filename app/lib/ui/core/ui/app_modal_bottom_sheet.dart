import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/dimens.dart';

class AppModalBottomSheet {
  AppModalBottomSheet._();

  static const _borderRadius = 16.0;
  static const _notchLineWidth = 50.0;
  static const _notchLineHeight = 2.0;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool enableDrag = true,
    bool isDismissable = true,
    bool isDetached = false,
    VoidCallback? onDismiss,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).colorScheme.onSecondary,
      ),
    );

    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      isDismissible: isDismissable,
      isScrollControlled: isDetached,
      backgroundColor: isDetached ? Colors.transparent : null,
      enableDrag: enableDrag,
      builder: (BuildContext builderContext) {
        return !isDetached
            ? _createBottomSheetContent(context: builderContext, child: child)
            : _createDetachedBottomSheetContent(
                context: builderContext,
                child: child,
              );
      },
    );
  }

  static Widget _createBottomSheetContent({
    required BuildContext context,
    required Widget child,
  }) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: Dimens.paddingVertical),
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                width: _notchLineWidth,
                height: _notchLineHeight,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimens.paddingHorizontal,
              Dimens.paddingVertical,
              Dimens.paddingHorizontal,
              Platform.isIOS
                  ? Dimens.paddingVertical
                  : MediaQuery.of(context).padding.bottom +
                        Dimens.paddingVertical,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  static Widget _createDetachedBottomSheetContent({
    required BuildContext context,
    required Widget child,
  }) {
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            Dimens.paddingHorizontal,
            Dimens.paddingVertical,
            Dimens.paddingHorizontal,
            MediaQuery.of(context).padding.bottom + Dimens.paddingHorizontal,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.paddingHorizontal,
                vertical: Dimens.paddingVertical,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
