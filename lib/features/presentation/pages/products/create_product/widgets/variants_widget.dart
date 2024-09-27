// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/action_selection_button.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_textform_field.dart';

class VariantsCreateWidget extends StatefulWidget {
  List<TextEditingController> nameControllers;
  List<TextEditingController> priceControllers;

  VariantsCreateWidget({
    super.key,
    required this.nameControllers,
    required this.priceControllers,
  });

  @override
  VariantsCreateWidgetState createState() => VariantsCreateWidgetState();
}

class VariantsCreateWidgetState extends State<VariantsCreateWidget> {
  void _addTextFields() {
    if (widget.nameControllers.length < 4) {
      widget.nameControllers.add(TextEditingController());
      widget.priceControllers.add(TextEditingController());
      setState(() {});
    }
  }

  void _removeTextFields(int index) {
    if (widget.nameControllers.isNotEmpty &&
        index < widget.nameControllers.length) {
      
      widget.nameControllers.removeAt(index);
      widget.priceControllers.removeAt(index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionSelectionButton(onTap: _addTextFields, text: 'Variants'),
        ...List.generate(
          widget.nameControllers.length,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: CustomTextField(
                    maxLength: 10,
                    hintText: 'Variant',
                    width: 1,
                    validator: (query) {
                      return Validation.variantValidation(query);
                    },
                    controller: widget.nameControllers[i],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextField(
                    maxLength: 5,
                    hintText: 'Price',
                    width: 1,
                    validator: (query) {
                      return Validation.validateNumber(query);
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
        ),
      ],
    );
  }
}
