import 'package:flutter/material.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlurredCirclesBackground(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FractionallySizedBox(
              widthFactor: 0.85,
              child: Image(image: AssetImage(Assets.notFound)),
            ),
            const SizedBox(height: Dimens.paddingVertical / 1.2),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: Text(
                context.localization.notFoundPageTitle,
                style: Theme.of(context).textTheme.headlineSmall!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimens.paddingVertical),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Text(
                context.localization.notFoundPageText,
                style: Theme.of(context).textTheme.bodyMedium!,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
