import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order history'),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('Order history'),
      ),
    );
  }
}
