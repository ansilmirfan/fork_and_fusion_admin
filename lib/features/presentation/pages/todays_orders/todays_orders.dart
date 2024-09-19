import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';

class TodaysOrders extends StatelessWidget {
  const TodaysOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's order"),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text("Today's order"),
      ),
    );
  }
}
