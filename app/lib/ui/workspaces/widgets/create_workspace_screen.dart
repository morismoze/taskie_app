import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../config/assets.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/app_text_form_field.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/create_workspace_viewmodel.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({super.key, required this.viewModel});

  final CreateWorkspaceViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
    widget.viewModel.createWorkspace.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateWorkspaceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createWorkspace.removeListener(_onResult);
    widget.viewModel.createWorkspace.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.createWorkspace.removeListener(_onResult);
    _nameController.dispose();
    _descriptionController.dispose();
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: Dimens.of(context).edgeInsetsScreenSymmetric,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage(Assets.createWorkspaceIllustration),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Text(
                              context.localization.workspaceCreateTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            ListenableBuilder(
                              listenable: widget.viewModel.load,
                              builder: (context, _) {
                                if (widget.viewModel.load.completed) {
                                  // This return is not defined inside child property of `ListenableBuilder`
                                  // because child is built only once, when the ListenableBuilder is built. And because
                                  // of that widget.viewModel.user is going to be captured as null.
                                  return Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      FractionallySizedBox(
                                        widthFactor: 0.75,
                                        child: Text(
                                          context.localization
                                              .workspaceCreateSubtitle(
                                                widget.viewModel.user!.email!,
                                              ),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        _buildForm(),
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

  void _onResult() {
    if (widget.viewModel.createWorkspace.completed) {
      GoRouter.of(context).go(Routes.tasks);
      widget.viewModel.createWorkspace.clearResult();
    }

    if (widget.viewModel.createWorkspace.error) {
      widget.viewModel.createWorkspace.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.errorWhileCreatingWorkspace,
      );
    }
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      widget.viewModel.createWorkspace.execute((name, description));
    }
  }

  String? _validateName(String? value) {
    switch (value) {
      case final String? value when value == null:
        return context.localization.requiredField;
      case final String value
          when value.length < ValidationRules.workspaceNameMinLength:
        return context.localization.workspaceCreateNameMinLength;
      case final String value
          when value.length > ValidationRules.workspaceNameMaxLength:
        return context.localization.workspaceCreateNameMaxLength;
      default:
        return null;
    }
  }

  String? _validateDescription(String? value) {
    switch (value) {
      case final String value
          when value.length > ValidationRules.workspaceDescriptionMaxLength:
        return context.localization.workspaceCreateDescriptionMaxLength;
      default:
        return null;
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          AppTextFormField(
            controller: _nameController,
            label: context.localization.workspaceNameLabel,
            validator: _validateName,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          AppTextFormField(
            controller: _descriptionController,
            label: context.localization.workspaceDescriptionLabel,
            validator: _validateDescription,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.go,
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: widget.viewModel.createWorkspace,
            builder: (context, _) => AppFilledButton(
              onPress: _onSubmit,
              label: context.localization.workspaceCreateLabel,
              isLoading: widget.viewModel.createWorkspace.running,
            ),
          ),
        ],
      ),
    );
  }
}
