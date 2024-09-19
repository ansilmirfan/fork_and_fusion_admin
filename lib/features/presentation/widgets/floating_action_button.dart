// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  void Function()? onPressed;
  CustomFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const OvalBorder(),
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
