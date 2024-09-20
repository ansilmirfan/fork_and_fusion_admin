import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_management_bloc.dart';

import 'package:fork_and_fusion_admin/features/presentation/widgets/pop.dart';

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required void Function()? onPressed,
  String description = '',
  bool textField = false,
  bool isLoading = false,
  TextEditingController? controller,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: Constants.radius,
        ),
        title: Text(title),
        content: textField ? _buildTextField(controller) : Text(description),
        actions: <Widget>[
          _cancelButton(context),
          _okButton(onPressed),
        ],
      );
    },
  );
}

BlocConsumer _okButton(void Function()? onPressed) {
  return BlocConsumer<CategoryManagementBloc, CategoryManagementState>(
    listener: (context, state) {
      if (state is CategoryManagemntCompletedState) {
        pop(context);
      }
    },
    builder: (context, state) {
      if (state is CategoryManagemntLoadingState) {
        return const ElevatedButton(
            onPressed: null, child: CircularProgressIndicator());
      }
      return ElevatedButton(
        onPressed: onPressed,
        child: const Text('OK'),
      );
    },
  );
}

TextButton _cancelButton(BuildContext context) {
  return TextButton(
    child: const Text(
      'Cancel',
    ),
    onPressed: () {
      pop(context);
    },
  );
}

SizedBox _buildTextField(TextEditingController? controller) {
  return SizedBox(
    width: double.infinity,
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          hintText: 'Enter your email',
          border: OutlineInputBorder(borderRadius: Constants.radius)),
    ),
  );
}
