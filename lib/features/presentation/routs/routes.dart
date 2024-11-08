import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';

import 'package:fork_and_fusion_admin/features/presentation/pages/category/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/category_search.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_view.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/dashboard/dashboard.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/order_history.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_view/order_view.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/create_product.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/product_view/product_view.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/products.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/search_products.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/qr%20code/qr_code_generator.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/repaymant/repayment.dart';
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
        return MaterialPageRoute(builder: (context) => TodaysOrders());

      case '/order history':
        return MaterialPageRoute(builder: (context) => const OrderHistory());

      case '/create product':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => CreateProduct(
              value: args['data'] as ProductEntity?,
              edit: args['edit'] as bool,
            ),
          );
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
                CategoryView(data: args),
          );
        }
        return errorRoutes();
      case '/product view':
        if (args is ProductEntity) {
          return MaterialPageRoute(
            builder: (context) => ProductView(data: args),
          );
        }
        return errorRoutes();
      case '/search products':
        return MaterialPageRoute(builder: (context) => SearchProducts());
      case '/qr code page':
        return MaterialPageRoute(builder: (context) => QrCodeGenerator());
      case '/orderview':
        if (args is OrderEntity) {
          return MaterialPageRoute(
              builder: (context) => OrderView(order: args));
        }
        errorRoutes();
      case '/repayment':
        return MaterialPageRoute(builder: (context) =>const Repayment());

      default:
        return errorRoutes();
    }
    return null;
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
