import 'package:flutter/material.dart';

import '../../../../data/services/api/paginable.dart';
import '../../../core/ui/app_select_field/app_select_field.dart';
import '../../../core/utils/extensions.dart';
import '../../view_models/tasks_screen_viewmodel.dart';
import 'sort_by_button.dart';

class SortByTimeButton extends StatelessWidget {
  const SortByTimeButton({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  void onSubmit(AppSelectFieldOption selectedOption) {
    final selectedSort = selectedOption.value as SortBy;
    final updatedFilter = viewModel.activeFilter.copyWith(sort: selectedSort);
    viewModel.loadTasks.execute((updatedFilter, null));
  }

  @override
  Widget build(BuildContext context) {
    return SortByButton(
      options: [
        AppSelectFieldOption(
          label: SortBy.newestFirst.l10n(context),
          value: SortBy.newestFirst,
        ),
        AppSelectFieldOption(
          label: SortBy.oldestFirst.l10n(context),
          value: SortBy.oldestFirst,
        ),
      ],
      activeValue: AppSelectFieldOption(
        label: viewModel.activeFilter.sort.l10n(context),
        value: viewModel.activeFilter.sort,
      ),
      onSubmit: onSubmit,
    );
  }
}
