import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../data/services/external/google/exceptions/google_sign_in_cancelled_exception.dart';
import '../../../../routing/routes.dart';
import '../../../../utils/command.dart';
import '../view_models/sign_in_viewmodel.dart';

const images = [
  [
    'assets/images/signin_notebook_object.png',
    'assets/images/signin_rocket_object.png',
    'assets/images/signin_zoom_object.png',
  ],
  [
    'assets/images/signin_crown_object.png',
    'assets/images/signin_target_object.png',
    'assets/images/signin_gym_object.png',
  ],
  [
    'assets/images/signin_gingerbread_object.png',
    'assets/images/signin_calendar_object.png',
    'assets/images/signin_snowman_object.png',
  ],
];

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
        statusBarColor: Colors.transparent,
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
    return FScaffold(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                ...images.map(
                  (rows) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...rows.map((image) => Image(image: AssetImage(image))),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: Column(
                  children: [
                    Text(
                      context.localization.signInTitleStart,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      context.localization.signInTitleEnd,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            ListenableBuilder(
              listenable: widget.viewModel.signInWithGoogle,
              builder: (context, _) => FButton(
                style: FButtonStyle.primary,
                onPress: () {
                  if (widget.viewModel.signInWithGoogle.running) {
                    return;
                  }
                  widget.viewModel.signInWithGoogle.execute();
                },
                child: widget.viewModel.signInWithGoogle.running == true
                    ? CupertinoActivityIndicator(color: Colors.white)
                    : Text(
                        context.localization.signIn,
                        style: TextStyle(fontSize: 20),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.signInWithGoogle.completed) {
      widget.viewModel.signInWithGoogle.clearResult();
      context.go(Routes.tasks);
    }

    if (widget.viewModel.signInWithGoogle.error) {
      final errorResult = widget.viewModel.signInWithGoogle.result as Error;

      switch (errorResult.error) {
        case GoogleSignInCancelledException():
          showFToast(
            context: context,
            title: Text(context.localization.signInGoogleCanceled),
          );
          break;
        default:
          showFToast(
            context: context,
            title: Text(context.localization.somethingWentWrong),
          );
      }

      widget.viewModel.signInWithGoogle.clearResult();
    }
  }
}
