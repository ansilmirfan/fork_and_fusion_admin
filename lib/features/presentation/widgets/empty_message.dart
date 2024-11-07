import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final String message;
  final bool expand;
  const EmptyMessage({super.key, required this.message, this.expand = false});
  factory EmptyMessage.expand({required String message}) {
    return EmptyMessage(message: message, expand: true);
  }

  @override
  Widget build(BuildContext context) {
    if (expand) {
      return Expanded(
          child: Center(
        child: Text(message),
      ));
    }
    return Center(
      child: Text(message),
    );
  }
}
