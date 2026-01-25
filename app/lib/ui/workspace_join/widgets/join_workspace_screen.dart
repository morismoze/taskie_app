import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/api_response.dart';
import '../../../data/services/api/exceptions/general_api_exception.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_toast.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/error_prompt.dart';
import '../../core/ui/separator.dart';
import '../../core/utils/extensions.dart';
import '../view_models/join_workspace_screen_view_model.dart';
import 'workspace_info.dart';

class JoinWorkspaceScreen extends StatefulWidget {
  const JoinWorkspaceScreen({super.key, required this.viewModel});

  final JoinWorkspaceScreenViewmodel viewModel;

  @override
  State<JoinWorkspaceScreen> createState() => _JoinWorkspaceScreenState();
}

class _JoinWorkspaceScreenState extends State<JoinWorkspaceScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.joinWorkspaceViaInviteLink.addListener(
      _onWorkspaceJoinResult,
    );
  }

  @override
  void didUpdateWidget(covariant JoinWorkspaceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.joinWorkspaceViaInviteLink.removeListener(
      _onWorkspaceJoinResult,
    );
    widget.viewModel.joinWorkspaceViaInviteLink.addListener(
      _onWorkspaceJoinResult,
    );
  }

  @override
  void dispose() {
    widget.viewModel.joinWorkspaceViaInviteLink.removeListener(
      _onWorkspaceJoinResult,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Dimens.of(context).paddingScreenHorizontal,
                      right: Dimens.of(context).paddingScreenHorizontal,
                      bottom: Dimens.of(context).paddingScreenVertical,
                      top: Dimens.of(context).paddingScreenVertical * 2,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListenableBuilder(
                          listenable:
                              widget.viewModel.fetchWorkspaceInfoByInviteToken,
                          builder: (builderContext, child) {
                            if (widget
                                .viewModel
                                .fetchWorkspaceInfoByInviteToken
                                .running) {
                              return const ActivityIndicator(radius: 16);
                            }

                            if (widget
                                .viewModel
                                .fetchWorkspaceInfoByInviteToken
                                .error) {
                              final error =
                                  widget
                                          .viewModel
                                          .fetchWorkspaceInfoByInviteToken
                                          .result
                                      as Error;
                              String errorMessage;

                              switch (error.error) {
                                case GeneralApiException(error: final apiError)
                                    when apiError.code ==
                                        ApiErrorCode
                                            .notFoundWorkspaceInviteToken:
                                  errorMessage = builderContext
                                      .localization
                                      .workspaceCreateJoinViaInviteLinkNotFound;
                                case GeneralApiException(error: final apiError)
                                    when apiError.code ==
                                        ApiErrorCode.invalidPayload:
                                  errorMessage = builderContext
                                      .localization
                                      .workspaceJoinViaInviteLinkInvalid;
                                default:
                                  errorMessage = builderContext
                                      .localization
                                      .workspaceJoinViaInviteWorkspaceInfoError;
                              }

                              return ErrorPrompt(
                                text: errorMessage,
                                onRetry: () => widget
                                    .viewModel
                                    .fetchWorkspaceInfoByInviteToken
                                    .execute(),
                              );
                            }

                            return child!;
                          },
                          child: ListenableBuilder(
                            listenable: Listenable.merge([
                              widget.viewModel,
                              widget.viewModel.joinWorkspaceViaInviteLink,
                            ]),
                            builder: (innerBuilderContext, _) => Column(
                              children: [
                                const SizedBox(
                                  height: Dimens.paddingVertical * 1.25,
                                ),
                                FaIcon(
                                  FontAwesomeIcons.envelopeCircleCheck,
                                  color: AppColors.green1,
                                  size: 45,
                                ),
                                const SizedBox(
                                  height: Dimens.paddingVertical / 1.2,
                                ),
                                Text(
                                  innerBuilderContext
                                      .localization
                                      .workspaceJoinViaInviteTitle,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                const SizedBox(
                                  height: Dimens.paddingVertical / 2.25,
                                ),
                                if (widget.viewModel.user != null)
                                  FractionallySizedBox(
                                    widthFactor: 0.7,
                                    child: innerBuilderContext.localization
                                        .workspaceJoinViaInviteText(
                                          widget.viewModel.user!.firstName,
                                        )
                                        .toStyledText(
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!,
                                          textAlign: TextAlign.center,
                                        ),
                                  ),

                                const SizedBox(
                                  height: Dimens.paddingVertical * 1.6,
                                ),
                                WorkspaceInfo(
                                  info: widget.viewModel.workspaceInfo!,
                                ),
                                const SizedBox(
                                  height: Dimens.paddingVertical * 1.6,
                                ),
                                const Separator(),
                                const SizedBox(height: Dimens.paddingVertical),
                                innerBuilderContext
                                    .localization
                                    .workspaceJoinViaInviteTextConfirm
                                    .toStyledText(
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!,
                                    ),
                                const SizedBox(
                                  height: Dimens.paddingVertical * 1.25,
                                ),
                                AppFilledButton(
                                  onPress: () => widget
                                      .viewModel
                                      .joinWorkspaceViaInviteLink
                                      .execute(),
                                  label: innerBuilderContext
                                      .localization
                                      .workspaceCreateJoinViaInviteLinkSubmit,
                                  loading: widget
                                      .viewModel
                                      .joinWorkspaceViaInviteLink
                                      .running,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onWorkspaceJoinResult() {
    if (widget.viewModel.joinWorkspaceViaInviteLink.completed) {
      final newWorkspaceId =
          (widget.viewModel.joinWorkspaceViaInviteLink.result as Ok<String>)
              .value;
      widget.viewModel.joinWorkspaceViaInviteLink.clearResult();
      AppToast.showInfo(
        context: context,
        message: context.localization.workspaceCreateJoinViaInviteLinkSuccess,
      );
      context.go(Routes.tasks(workspaceId: newWorkspaceId));
    }

    if (widget.viewModel.joinWorkspaceViaInviteLink.error) {
      final errorResult =
          widget.viewModel.joinWorkspaceViaInviteLink.result as Error;
      widget.viewModel.joinWorkspaceViaInviteLink.clearResult();

      switch (errorResult.error) {
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.notFoundWorkspaceInviteToken:
          AppToast.showError(
            context: context,
            message:
                context.localization.workspaceCreateJoinViaInviteLinkNotFound,
          );
          break;
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.workspaceInviteExpired:
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.workspaceInviteAlreadyUsed:
          AppToast.showInfo(
            context: context,
            message: context
                .localization
                .workspaceCreateJoinViaInviteLinkExpiredOrUsed,
          );
          break;
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.workspaceInviteExistingUser:
          AppToast.showInfo(
            context: context,
            message:
                context.localization.workspaceJoinViaInviteLinkExistingUser,
          );
          context.go(
            Routes.tasks(workspaceId: widget.viewModel.workspaceInfo!.id),
          );
          break;
        default:
          AppToast.showError(
            context: context,
            message: context.localization.workspaceCreateJoinViaInviteLinkError,
          );
      }
    }
  }
}
