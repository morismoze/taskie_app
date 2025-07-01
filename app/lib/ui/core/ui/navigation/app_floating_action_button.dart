import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../util/constants.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({super.key});

  @override
  Widget build(Object context) {
    return SizedBox(
      width: kAppFloatingActionButtonSize,
      height: kAppFloatingActionButtonSize,
      child: FloatingActionButton(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () => print('yes'),
        child: const FaIcon(FontAwesomeIcons.plus, size: 18),
      ),
    );
  }
}
