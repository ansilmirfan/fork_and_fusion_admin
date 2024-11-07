import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';

class TabBarItem extends StatelessWidget {
  final String text;
  const TabBarItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          BoxDecoration(border: Border.all(), borderRadius: Constants.radius),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(text),
        ),
      ),
    );
  }
}
