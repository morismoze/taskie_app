import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/colors.dart';

class WorkspaceSwitcher extends StatelessWidget {
  const WorkspaceSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: const FaIcon(
          FontAwesomeIcons.solidCompass,
          size: 25,
          color: AppColors.black1,
        ),
      ),
    );
  }
}
