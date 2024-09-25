// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class Constants {
  static GlobalKey<FormState> product = GlobalKey<FormState>();
  static GlobalKey<FormState> signIn = GlobalKey<FormState>();
  static Map<String, String> deleteMessage = {
    'Confirm Deletion':
        'This action will permanently remove this item. Do you want to proceed?'
  };

  static var radius = BorderRadius.circular(10);
  static var dWidth = 0.0;
  static var dHeight = 0.0;
  static var none = const SizedBox.shrink();
  static var padding10 = const EdgeInsets.all(10);
  static var padding15 = const EdgeInsets.all(15);

  static var image =
      'https://imgs.search.brave.com/36UiHPC4R-fCsU2NXqJIz-9BghaENOxDjpepP76LTSU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzA2LzA4Lzg0LzI0/LzM2MF9GXzYwODg0/MjQxM19oZFlhZHA2/dVNDN2M3cHE2TEpl/dzlzOGdQblJTZ2ps/bi5qcGc';
}

enum ListType {
  productView,
  cartView,
  historyView,
  historyViewToday,
}

enum ProductType {
  seasonal,
  todays_special,
  todays_list,
}
