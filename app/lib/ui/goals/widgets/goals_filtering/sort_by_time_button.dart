import 'package:flutter/material.dart';

import '../../../../data/services/api/paginable.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/ui/app_select_field/app_select_field.dart';
import '../../../core/ui/sort_by_button.dart';
import '../../../core/utils/extensions.dart';
import '../../view_models/goals_screen_view_model.dart';

class SortByTimeButton extends StatelessWidget {
  const SortByTimeButton({super.key, required this.viewModel});

  final GoalsScreenViewModel viewModel;

  void onSubmit(AppSelectFieldOption selectedOption) {
    final selectedSort = selectedOption.value as SortBy;
    final updatedFilter = viewModel.activeFilter.copyWith(sort: selectedSort);
    viewModel.loadGoals.execute((updatedFilter, null));
  }

  @override
  Widget build(BuildContext context) {
    return SortByButton(
      title: context.localization.objectiveTimeFilter,
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
