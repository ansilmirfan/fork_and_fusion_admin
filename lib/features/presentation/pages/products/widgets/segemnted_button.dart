import 'package:flutter/material.dart';

class CustomSegementedButton extends StatelessWidget {
  Set<String> selected;
  void Function(Set<String>)? onSelectionChanged;
  CustomSegementedButton(
      {super.key, required this.selected, required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(150),
      color: Theme.of(context).colorScheme.tertiary,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: SegmentedButton<String>(
          multiSelectionEnabled: false,
          style:
              const ButtonStyle(side: WidgetStatePropertyAll(BorderSide.none)),
          selected: selected,
          onSelectionChanged: onSelectionChanged,
          segments: const [
            ButtonSegment<String>(value: 'Price', icon: Text('Price')),
            ButtonSegment<String>(value: 'Variants', icon: Text('Variants')),
          ],
        ),
      ),
    );
  }
}
