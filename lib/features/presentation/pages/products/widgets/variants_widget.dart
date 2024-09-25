// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/action_selection_button.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_textform_field.dart';

class VariantSelection extends StatefulWidget {
  List<TextEditingController> nameControllers;
  List<TextEditingController> priceControllers;
  VariantSelection(
      {super.key,
      required this.nameControllers,
      required this.priceControllers});

  @override
  VariantSelectionState createState() => VariantSelectionState();
}

class VariantSelectionState extends State<VariantSelection> {
  void _addTextFields() {
    if (widget.nameControllers.length < 4) {
      widget.nameControllers.add(TextEditingController());
      widget.priceControllers.add(TextEditingController());

      setState(() {});
    }
  }

  void _removeTextFields(int index) {
    if (widget.nameControllers.isNotEmpty) {
      widget.nameControllers.removeAt(index);
      widget.priceControllers.removeAt(index);

      setState(() {});
    }
  }

  // void getVariants() {
  //   Map<String, num> variants = {};
  //   for (var i = 0; i < nameControllers.length; i++) {
  //     if (nameControllers[i].text.isNotEmpty &&
  //         priceControllers[i].text.isNotEmpty) {
  //       variants[nameControllers[i].text] =
  //           num.tryParse(priceControllers[i].text) ?? 0;
  //     }
  //   }

  //   GlobalVaribles.variants = variants;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionSelectionButton(onTap: () => _addTextFields(), text: 'Variants'),
        for (int i = 0; i < widget.nameControllers.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: CustomTextField(
                    maxLength: 10,
                    hintText: 'Variant',
                    width: .9,
                    validator: (querry) {
                      return Validation.variantValidation(querry);
                    },
                    controller: widget.nameControllers[i],
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    maxLength: 5,
                    hintText: ' Price',
                    width: .9,
                    validator: (querry) {
                      return Validation.validateNumber(querry);
                    },
                    controller: widget.priceControllers[i],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _removeTextFields(i),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
