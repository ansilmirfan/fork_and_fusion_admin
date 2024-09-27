import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';

void showCustomAlertDialog(
    {required BuildContext context,
    required String title,
    void Function()? onPressed,
    String description = '',
    bool textField = false,
    BlocConsumer? okbutton,
    SizedBox? textformField}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: Constants.radius),
        title: Text(title),
        content: textField ? textformField : Text(description),
        actions: [
          _cancelButton(context),
          okbutton ?? _okButton(okbutton, onPressed),
         
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
