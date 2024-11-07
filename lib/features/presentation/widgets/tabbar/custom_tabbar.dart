import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';

class CustomTabbar extends StatelessWidget {
  final List<Widget> tabs;
  final bool isScrollable;


  const CustomTabbar(
      {super.key,
      required this.tabs,
      this.isScrollable = false,
 });

  @override
  Widget build(BuildContext context) {
    return TabBar(
 
      isScrollable: isScrollable,
      dividerHeight: 0.0,
      labelStyle: Theme.of(context).textTheme.labelLarge,
      indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: Constants.radius),
      tabs: tabs,
    );
  }
}
