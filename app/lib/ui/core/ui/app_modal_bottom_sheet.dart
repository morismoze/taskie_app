import 'package:flutter/material.dart';

import '../theme/dimens.dart';

const _borderRadius = 16.0;

class AppModalBottomSheet {
  AppModalBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool enableDrag = true,
    bool isDismissable = true,
    bool isDetached = false,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      isDismissible: isDismissable,
      isScrollControlled: isScrollControlled || isDetached,
      backgroundColor: isDetached ? Colors.transparent : null,
      enableDrag: enableDrag,
      builder: (BuildContext builderContext) {
        if (isDetached) {
          return _DetachedBottomSheetContent(child: child);
        }

        return child;
      },
    );
  }
}

class _DetachedBottomSheetContent extends StatelessWidget {
  const _DetachedBottomSheetContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
