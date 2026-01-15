import 'package:flutter/material.dart';

import '../theme/dimens.dart';

class EmptyDataPlaceholder extends StatelessWidget {
  const EmptyDataPlaceholder({
    super.key,
    required this.assetImage,
    required this.child,
  });

  final String assetImage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.85,
          child: Image(image: AssetImage(assetImage)),
        ),
        const SizedBox(height: Dimens.paddingVertical),
        FractionallySizedBox(widthFactor: 0.9, child: child),
      ],
    );
  }
}
