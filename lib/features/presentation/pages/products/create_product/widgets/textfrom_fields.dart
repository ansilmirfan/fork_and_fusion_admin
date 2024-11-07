import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/other/variables.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/widgets/variants_widget.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/segemnted_button.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_textform_field.dart';

Column buildTextFromFields(CreateProductVaribles variables) {
  var gap = const SizedBox(height: 10);
  return Column(
    children: [
      gap,
      CustomTextField(
        hintText: 'Product Name',
        validator: (querry) {
          return Validation.validateName(querry,
              minLength: 3, name: 'product name');
        },
        controller: variables.nameController,
        width: 1,
      ),
      gap,
      CustomTextField(
        hintText: 'Ingrediants',
        maxLength: 400,
        validator: (querry) {
          return Validation.validateName(querry,
              minLength: 10, name: 'Ingrediants');
        },
        controller: variables.ingrediantsController,
        width: 1,
        multiLine: 6,
      ),
      gap,
      StatefulBuilder(
        builder: (context, setState) => Column(
          children: [
            CustomSegementedButton(
                selected: variables.selected,
                onSelectionChanged: (s) =>
                    setState(() => variables.selected = s)),
            gap,
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: variables.selected.first == 'Price'
                  ? CustomTextField(
                      hintText: 'Price',
                      validator: (querry) {
                        return Validation.validateNumber(querry,
                            minValue: 2, name: 'price');
                      },
                      maxLength: 5,
                      controller: variables.priceController,
                      width: 1,
                      keyboardType: TextInputType.number,
                    )
                  : VariantsCreateWidget(
                      nameControllers: variables.nameControllers,
                      priceControllers: variables.priceControllers),
            ),
          ],
        ),
      ),
      gap,
      CustomTextField(
        hintText: 'Offer',
        maxLength: 2,
        validator: (querry) {
          return Validation.validatePercentage(querry);
        },
        controller: variables.offerController,
        helperText: '% 1-99',
        width: 1,
      ),
      gap,
    ],
  );
}
