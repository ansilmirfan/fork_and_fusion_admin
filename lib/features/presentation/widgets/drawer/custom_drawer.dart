// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/drawer_page/drawer_page_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/drawer_items.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: BlocBuilder<DrawerPageBloc, DrawerPageState>(
          builder: (context, state) {
            int selected =
                (state is DrawerPageChangedState) ? state.currentPage : 0;

            return ListView(
              padding: EdgeInsets.zero,
              children: List.generate(
                DrawerItems.text.length,
                (index) => DrawerTile(
                  selected: index == selected,
                  icon: DrawerItems.icon[index],
                  onTap: () async {
                    context
                        .read<DrawerPageBloc>()
                        .add(DrawerPageChangedEvent(index));
                    await Future.delayed(const Duration(milliseconds: 300));
                    Navigator.of(context)
                        .pushReplacementNamed(DrawerItems.route[index]);
                  },
                  text: DrawerItems.text[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
