import 'package:flutter/material.dart';

class DrawerItems {
  static List<String> text = [
    'DashBoard',
    'Products',
    'Category',
    "Today's orders",
    'Order History'
  ];
  static List<IconData> icon = [
    Icons.incomplete_circle,
    Icons.shopify_rounded,
    Icons.grid_view_outlined,
    Icons.notifications_active_outlined,
    Icons.history,
  ];
  static List<String> route = [
    '/dashboard',
    '/product',
    '/category',
    "/today's orders",
    '/order history'
  ];
}
