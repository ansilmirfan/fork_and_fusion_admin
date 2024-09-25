import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/category_search.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_view.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/dashboard/dashboard.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/order_history.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/create_product.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/product_view/product_view.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/products.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/sign_in/sign_in.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/splash_screen/splash_screen.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/todays_orders/todays_orders.dart';

class Routes {
  static Route<dynamic>? routes(RouteSettings s) {
    final args = s.arguments;
    switch (s.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case '/signin':
        return MaterialPageRoute(builder: (context) => SignIn());
      case '/dashboard':
        return MaterialPageRoute(builder: (context) => const Dashboard());
      case '/product':
        return MaterialPageRoute(builder: (context) => Products());
      case '/category':
        return MaterialPageRoute(builder: (context) => const Category());
      case "/today's orders":
        return MaterialPageRoute(builder: (context) => const TodaysOrders());
      case '/order history':
        return MaterialPageRoute(builder: (context) => const OrderHistory());
      case '/create product':
        if (args is CategorySelectingBloc) {
          return MaterialPageRoute(
              builder: (context) => CreateProduct(selectionBloc: args));
        }
        return errorRoutes();

      case '/category search':
        return MaterialPageRoute(builder: (context) => CategorySearch());
      case '/category details':
        if (args is CategoryEntity) {
          return PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  CategoryView(data: args));
        }
        return errorRoutes();
      case '/product view':
        if (args is ProductEntity) {
          return MaterialPageRoute(
              builder: (context) => ProductView(data: args));
        }
        return errorRoutes();

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
