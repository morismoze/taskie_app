import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/dimens.dart';

class AppModalBottomSheet {
  AppModalBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool isDismissable = true,
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
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissable,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext builderContext) {
        return _createBottomSheetContent(context: builderContext, child: child);
      },
    ).whenComplete(() {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
      if (onDismiss != null) {
        onDismiss();
      }
    });
  }

  static Widget _createBottomSheetContent({
    required BuildContext context,
    required Widget child,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingVertical),
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              width: 50,
              height: 2,
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
    );
  }
}
