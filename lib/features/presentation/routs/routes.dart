import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/category_search.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/dashboard/dashboard.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/order_history.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/create_product.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/products.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/sign_in/sign_in.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/splash_screen/splash_screen.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/todays_orders/todays_orders.dart';

class Routes {
  static Route<dynamic>? routes(RouteSettings s) {
    switch (s.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case '/signin':
        return MaterialPageRoute(builder: (context) => SignIn());
      case '/dashboard':
        return MaterialPageRoute(builder: (context) => const Dashboard());
      case '/product':
        return MaterialPageRoute(builder: (context) => const Products());
      case '/category':
        return MaterialPageRoute(builder: (context) => const Category());
      case "/today's orders":
        return MaterialPageRoute(builder: (context) => const TodaysOrders());
      case '/order history':
        return MaterialPageRoute(builder: (context) => const OrderHistory());
      case '/create product':
        return MaterialPageRoute(builder: (context) => const CreateProduct());
      case '/category search':
        return MaterialPageRoute(builder: (context) =>  CategorySearch());

      default:
        return errorRoutes();
    }
  }

  static Route<dynamic>? errorRoutes() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
