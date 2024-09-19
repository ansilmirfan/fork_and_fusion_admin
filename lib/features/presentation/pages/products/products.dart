import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/floating_action_button.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('Products'),
      ),
      floatingActionButton: CustomFloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/create product')),
    );
  }
}
