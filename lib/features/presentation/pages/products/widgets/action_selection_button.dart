import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';

class ActionSelectionButton extends StatelessWidget {
  void Function()? onTap;
  String text;
  ActionSelectionButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: Constants.radius,
      color: Theme.of(context).colorScheme.tertiary,
      child: InkWell(
        borderRadius: Constants.radius,
        onTap: onTap,
        child: Container(
          padding: Constants.padding10,
          height: 50,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text),
              const Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }
}
