import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';

void showCustomAlertDialog(
    {required BuildContext context,
    required String title,
    void Function()? onPressed,
    String description = '',
    bool textField = false,
    bool error = false,
    bool customOkButton = false,
    BlocConsumer? okbutton,
    SizedBox? textformField}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: Constants.radius),
        title: _titile(title, error, context),
        //------------either textfield or description----------------
        content: textField
            ? textformField
            : Text(
                description,
                style: TextStyle(
                    color: error ? Theme.of(context).colorScheme.error : null),
              ),
        actions: [
          _cancelButton(context),
          //---------------button with loading----------------
          okbutton ?? Constants.none,
          //----------------default ok button visible with bool-----------------
          _okButton(customOkButton, onPressed),
        ],
      );
    },
  );
}

Text _titile(String title, bool error, BuildContext context) {
  return Text(
    title,
    style: TextStyle(color: error ? Theme.of(context).colorScheme.error : null),
  );
}

Visibility _okButton(bool visibility, void Function()? onPressed) {
  return Visibility(
    visible: visibility,
    child: ElevatedButton(
      onPressed: onPressed,
      child: const Text('Ok'),
    ),
  );
}

TextButton _cancelButton(BuildContext context) {
  return TextButton(
    child: const Text('Cancel'),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}
