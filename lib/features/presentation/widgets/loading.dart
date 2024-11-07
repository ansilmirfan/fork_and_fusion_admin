import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool expand;
  const Loading({super.key, this.expand = false});

  @override
  Widget build(BuildContext context) {
    if (expand) {
      return const Expanded(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }
    return const Center(child: CircularProgressIndicator());
  }
}
