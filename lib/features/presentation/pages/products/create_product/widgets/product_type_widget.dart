import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';

class ProductTypeWidget extends StatelessWidget {
  List<bool> selected;
  ProductTypeWidget({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.tertiary,
      elevation: 10,
      borderRadius: Constants.radius,
      child: StatefulBuilder(
        builder: (context, setState) => Container(
          padding: Constants.padding10,
          child: Column(
            children: [
              Text(
                'Type',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              ...List.generate(
                3,
                (index) => CheckboxListTile(
                  value: selected[index],
                  onChanged: (value) {
                    setState(() => selected[index] = !selected[index]);
                  },
                  title: Text(
                    Utils.removeAndCapitalize(ProductType.values[index].name),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
