import 'package:flutter/material.dart';

import '../../../../data/services/api/workspace/progress_status.dart';
import '../../../core/ui/app_select_field/app_select_field.dart';
import '../../../core/utils/extensions.dart';
import '../../view_models/tasks_screen_viewmodel.dart';
import 'sort_by_button.dart';

class SortByStatusButton extends StatelessWidget {
  const SortByStatusButton({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  void onSubmit(AppSelectFieldOption selectedOption) {
    final selectedStatus = selectedOption.value as ProgressStatus;
    final updatedFilter = viewModel.activeFilter.copyWith(
      status: selectedStatus,
    );
    viewModel.loadTasks.execute((updatedFilter, null));
  }

  @override
  Widget build(BuildContext context) {
    return SortByButton(
      options: [
        AppSelectFieldOption(
          label: ProgressStatus.inProgress.l10n(context),
          value: ProgressStatus.inProgress,
        ),
        AppSelectFieldOption(
          label: ProgressStatus.completed.l10n(context),
          value: ProgressStatus.completed,
        ),
        AppSelectFieldOption(
          label: ProgressStatus.completedAsStale.l10n(context),
          value: ProgressStatus.completedAsStale,
        ),
        AppSelectFieldOption(
          label: ProgressStatus.closed.l10n(context),
          value: ProgressStatus.closed,
        ),
      ],
      activeValue: AppSelectFieldOption(
        label: viewModel.activeFilter.status.l10n(context),
        value: viewModel.activeFilter.status,
      ),
      activeValueLabel: viewModel.activeFilter.status.l10n(context),
      onSubmit: onSubmit,
    );
  }
}
