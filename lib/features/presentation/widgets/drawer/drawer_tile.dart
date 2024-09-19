// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';

class DrawerTile extends StatelessWidget {
  String text;
  IconData? icon;
  bool selected;
  void Function()? onTap;

  DrawerTile(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.text,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            borderRadius: Constants.radius,
            elevation: 10,
            child: const ListTile(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: selected ? 500 : 0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: Constants.radius,
            ),
            child: const ListTile(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            iconColor: selected
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.onSurface,
            leading: Icon(icon),
            title: Text(
              text,
              style: TextStyle(
                color: selected
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
