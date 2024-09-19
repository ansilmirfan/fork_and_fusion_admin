import 'package:flutter/material.dart';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';

void showCustomAlertDialog(
    {required BuildContext context,
    required String title,
    required void Function()? onPressed,
    String description = '',
    bool textField = false,
    TextEditingController? controller}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: Constants.radius,
        ),
        title: Text(
          title,
        ),
        content: textField
            ? SizedBox(
                width: double.infinity,
                child:TextFormField(
                  controller: controller,
                
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(borderRadius: Constants.radius)
                  ),
                ),
              )
            : Text(
                description,
              ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text(
              'OK',
            ),
          ),
        ],
      );
    },
  );
}
