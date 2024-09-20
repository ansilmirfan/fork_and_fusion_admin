// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';

class CustomeTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon? prefixIcon;
  final void Function(String)? onChanged;
  bool obsuceText;
  final bool suffixIcon;
  final bool search;
  final bool doubleLine;
  final String? Function(String?)? validator;
  TextInputType? keyboardType;
  double width;

  CustomeTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.onChanged,
    this.obsuceText = false,
    this.suffixIcon = false,
    this.search = false,
    this.doubleLine = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.width = .90,
  });

  @override
  State<CustomeTextField> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Material(
              elevation: 10,
              borderRadius: Constants.radius,
              color: Theme.of(context).colorScheme.tertiary,
              child: SizedBox(
                width: constraints.maxWidth * widget.width,
                child: TextFormField(
                  enabled: false,
                  maxLines: widget.doubleLine ? 2 : 1,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth *  widget.width,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged,
                validator: widget.validator,
                controller: widget.controller,
                obscureText: widget.obsuceText,
                maxLines: widget.doubleLine ? 2 : 1,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 15.0,
                  ),
                  hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
              
                  border: InputBorder.none,
                  
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon
                      ? widget.search
                          ? _textFieldClearButton()
                          : _obscureEyeButton()
                      : null,
                  errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                  errorBorder: _errorBorder(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _errorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: Constants.radius,
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
    );
  }

  InkWell _obscureEyeButton() {
    return InkWell(
      onTap: () {
        setState(() {
          widget.obsuceText = !widget.obsuceText;
        });
      },
      child: Icon(
        Icons.remove_red_eye,
        color: widget.obsuceText ? Colors.grey : Colors.blue,
      ),
    );
  }

  InkWell _textFieldClearButton() {
    return InkWell(
      onTap: () {
        widget.controller.clear();
      },
      child: const Icon(Icons.close),
    );
  }
}
