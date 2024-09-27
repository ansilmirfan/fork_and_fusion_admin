// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';

class CustomTextButton extends StatelessWidget {
  String text;
  void Function()? onPressed;

  bool progress;
  Icon? icon;
  double width;
  CustomTextButton(
      {super.key,
      this.text = '',
      this.onPressed,
      this.progress = false,
      this.width=0.9,
      this.icon});

  @override
  Widget build(BuildContext context) {
    bool isEnabled = onPressed != null;
    return SizedBox(
      width: Constants.dWidth * width,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 10,
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              isEnabled ? const Color(0xFFFF6B01) : Colors.grey,
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            minimumSize: const WidgetStatePropertyAll(
              Size(double.infinity, 50),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              Visibility(
                visible: icon != null,
                child: icon ?? const SizedBox.shrink(),
              ),
              const Spacer(),
              progress
                  ? Row(
                      children: [
                        Text(text),
                        const SizedBox(width: 10),
                        const CircularProgressIndicator(),
                      ],
                    )
                  : Text(
                      text,
                      style: const TextStyle(fontSize: 20),
                    ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
