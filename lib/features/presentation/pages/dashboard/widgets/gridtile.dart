import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/elevated_container.dart';

class Gridtile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  const Gridtile(
      {super.key,
      required this.title,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30,
          color: Colors.blue,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(value),
      ],
    ));
  }
}
