import 'package:flutter/cupertino.dart';

import '../../../core/ui/activity_indicator.dart';
import '../../view_models/goals_screen_viewmodel.dart';
import 'filter_by_status_button.dart';
import 'sort_by_time_button.dart';

class GoalsFilteringHeader extends StatelessWidget {
  const GoalsFilteringHeader({super.key, required this.viewModel});

  final GoalsScreenViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 13,
      children: [
        SortByTimeButton(viewModel: viewModel),
        FilterByStatusButton(viewModel: viewModel),
        const Spacer(),
        ListenableBuilder(
          listenable: viewModel.loadGoals,
          builder: (_, child) {
            // Show loader in cases it's not force fetch
            if (viewModel.loadGoals.running && !viewModel.isForceFetching) {
              return child!;
            }
            return const SizedBox.shrink();
          },
          child: const ActivityIndicator(radius: 12),
        ),
      ],
    );
  }
}
