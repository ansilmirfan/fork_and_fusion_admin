import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_alert_dialog.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_textform_field.dart';

offerUpdatingDialog(
    {required BuildContext context, required ProductEntity data}) {
  TextEditingController controller = TextEditingController();
  controller.text = data.offer.toString();
  showCustomAlertDialog(
    context: context,
    title: "Offer",
    textField: true,
    okbutton: okButton(context.read<ProductManagementBloc>(), data, controller),
    textformField: SizedBox(
      width: Constants.dWidth / 2,
      child: CustomTextField(
        keyboardType: TextInputType.number,
        width: 1,
        hintText: 'offer',
        validator: (querry) {
          return Validation.validateNumber(querry);
        },
        maxLength: 2,
        helperText: '% 1-99',
        controller: controller,
      ),
    ),
  );
}

BlocConsumer okButton(ProductManagementBloc bloc, ProductEntity data,
    TextEditingController controller) {
  return BlocConsumer<ProductManagementBloc, ProductManagementState>(
    bloc: bloc,
    listener: (context, state) {
      if (state is ProductManagementCompletedState) {
        Navigator.of(context).pop();
      }
    },
    builder: (context, state) {
      if (state is ProductManagementLoadingState) {
        return const ElevatedButton(
            onPressed: null, child: CircularProgressIndicator());
      }
      return ElevatedButton(
        onPressed: () {
          data.offer = int.tryParse(controller.text.trim()) ?? 0;
          context
              .read<ProductManagementBloc>()
              .add(ProductManagementEditEvent(data.id, data));
        },
        child: const Text('OK'),
      );
    },
  );
}
