import 'package:flutter/material.dart';

import '../../../../data/services/api/workspace/progress_status.dart';
import '../../../../domain/models/filter.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/ui/app_select_field/app_select_field.dart';
import '../../../core/ui/sort_by_button.dart';
import '../../../core/utils/extensions.dart';
import '../../view_models/tasks_screen_view_model.dart';

class FilterByStatusButton extends StatelessWidget {
  const FilterByStatusButton({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  void onSubmit(AppSelectFieldOption selectedOption) {
    ObjectiveFilter? updatedFilter;

    if (selectedOption.value is ProgressStatus) {
      final selectedStatus = selectedOption.value as ProgressStatus;
      updatedFilter = viewModel.activeFilter.copyWith(status: selectedStatus);
    } else {
      // Default noSortByStatusOption (`All`) was chosen
      updatedFilter = viewModel.activeFilter.copyWith(status: null);
    }

    viewModel.loadTasks.execute((updatedFilter, null));
  }

  @override
  Widget build(BuildContext context) {
    final noSortByStatusOption = AppSelectFieldOption(
      label: context.localization.objectiveStatusFilterAll,
      value: null,
    );
    final valuesList = [
      noSortByStatusOption,
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
    ];
    final activeValue = viewModel.activeFilter.status != null
        ? AppSelectFieldOption(
            label: viewModel.activeFilter.status!.l10n(context),
            value: viewModel.activeFilter.status,
          )
        : noSortByStatusOption;

    return SortByButton(
      title: context.localization.objectiveStatusFilter,
      options: valuesList,
      activeValue: activeValue,
      onSubmit: onSubmit,
    );
  }
}
