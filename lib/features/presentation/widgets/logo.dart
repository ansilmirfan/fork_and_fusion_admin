import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Logo extends StatelessWidget {
  double? width;
  Logo({super.key,this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset('asset/images/fork fution.png',width: width,);
  }
}
