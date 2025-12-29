import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../config/assets.dart';
import '../../../../data/services/external/google/exceptions/google_sign_in_cancelled_exception.dart';
import '../../../../utils/command.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/dimens.dart';
import '../../../core/ui/app_filled_button.dart';
import '../../../core/ui/app_modal_bottom_sheet.dart';
import '../../../core/ui/app_modal_bottom_sheet_content_wrapper.dart';
import '../../../core/ui/app_snackbar.dart';
import '../../../core/ui/blurred_circles_background.dart';
import '../view_models/sign_in_viewmodel.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.viewModel});

  final SignInViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
    widget.viewModel.signInWithGoogle.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant SignInScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.signInWithGoogle.removeListener(_onResult);
    widget.viewModel.signInWithGoogle.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.signInWithGoogle.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Padding(
            padding: Dimens.of(context).edgeInsetsScreenHorizontal.copyWith(
              top: Dimens.of(context).paddingScreenVertical,
              bottom: Dimens.of(context).paddingScreenVertical * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 3,
                  child: FractionallySizedBox(
                    widthFactor: 0.85,
                    child: Image(image: AssetImage(Assets.signInIllustration)),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        context.localization.signInTitleStart,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        context.localization.signInTitleEnd,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      FractionallySizedBox(
                        widthFactor: 0.75,
                        child: Text(
                          context.localization.signInSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 50),
                      ListenableBuilder(
                        listenable: widget.viewModel.signInWithGoogle,
                        builder: (BuildContext builderContext, _) =>
                            AppFilledButton(
                              onPress: () => _onSignInStart(builderContext),
                              label:
                                  builderContext.localization.signInGetStarted,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.signInWithGoogle.completed) {
      widget.viewModel.signInWithGoogle.clearResult();
    }

    if (widget.viewModel.signInWithGoogle.error) {
      final errorResult = widget.viewModel.signInWithGoogle.result as Error;
      widget.viewModel.signInWithGoogle.clearResult();

      switch (errorResult.error) {
        case GoogleSignInCancelledException():
          AppSnackbar.showInfo(
            context: context,
            message: context.localization.signInGoogleCanceled,
          );
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.signInGoogleError,
          );
      }
    }
  }

  void _onSignInStart(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
      enableDrag: false,
      isDismissable: false,
      // Even though the entire outer AppFilledButton is inside ListenableBuilder, the child
      // of the bottom sheet snapshots current state of `widget.viewModel.signInWithGoogle` when
      // opened (something like closure). Hence why it also needs to be wrapped inside ListenableBuilder
      child: ListenableBuilder(
        listenable: widget.viewModel.signInWithGoogle,
        builder: (BuildContext builderContext, _) =>
            AppModalBottomSheetContentWrapper(
              title: context.localization.signInTitleProviders,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppFilledButton(
                  onPress: () => widget.viewModel.signInWithGoogle.execute(),
                  label: builderContext.localization.signInViaGoogle,
                  leadingIcon: FontAwesomeIcons.google,
                  loading: widget.viewModel.signInWithGoogle.running,
                  backgroundColor: Colors.red[800],
                ),
              ),
            ),
      ),
    );
  }
}
