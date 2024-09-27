import 'package:flutter/material.dart';

class CreateProductVaribles{
    TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  List<bool> selectedTypes = List.generate(4, (index) => index == 2);
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> priceControllers = [];
  TextEditingController ingrediantsController = TextEditingController();
  var gap = const SizedBox(height: 10);
  Set<String> selected = {'Price'};
}