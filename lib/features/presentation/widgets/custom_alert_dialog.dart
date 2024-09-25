import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';



void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  void Function()? onPressed,
  String description = '',
  bool textField = false,
  BlocConsumer? okbutton,
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
          _okButton(okbutton, onPressed),
          Visibility(visible: okbutton != null, child: okbutton!),
        ],
      );
    },
  );
}

Visibility _okButton(BlocConsumer? okbutton, void Function()? onPressed) {
  return Visibility(
    visible: okbutton == null,
    child: ElevatedButton(
      onPressed: onPressed,
      child: const Text(
        'Ok',
      ),
    ),
  );
}

TextButton _cancelButton(BuildContext context) {
  return TextButton(
    child: const Text(
      'Cancel',
    ),
    onPressed: () {
     Navigator.of(context).pop();
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
