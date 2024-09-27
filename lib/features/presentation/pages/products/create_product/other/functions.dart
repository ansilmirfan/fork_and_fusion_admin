  import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';

Map<String, num> getVariants(List<TextEditingController>nameControllers,List<TextEditingController>priceControllers,) {
    Map<String, num> varints = {};
    for (var i = 0; i < nameControllers.length; i++) {
      varints[nameControllers[i].text.trim()] =
          num.parse(priceControllers[i].text.trim());
    }
    return varints;
  }

  List<ProductType> getSelectedType(List<bool> selected) {
    List<ProductType> type = [];
    for (var i = 0; i < 3; i++) {
      if (selected[i]) {
        type.add(ProductType.values[i]);
      }
    }
    return type;
  }