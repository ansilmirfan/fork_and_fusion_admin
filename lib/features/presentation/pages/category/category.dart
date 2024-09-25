// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';

import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_listtile.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_bottom_sheet.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/floating_action_button.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryManagementBloc>().add(CategoryManagemntGetAllEvent());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: Constants.padding10,
          child: _buildListView(),
        ),
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Category'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/category search');
          },
          icon: const Icon(Icons.search),
        )
      ],
    );
  }

  BlocBuilder<CategoryManagementBloc, CategoryManagementState>
      _buildListView() {
    return BlocBuilder<CategoryManagementBloc, CategoryManagementState>(
      builder: (context, state) {
        if (state is CategoryManagemntLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CategoryManagemntCompletedState) {
          var data = state.data;
          if (data.isEmpty) {
            return _centerText(
                'Looks like there are no categories yet. Add some to get started!');
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<CategoryManagementBloc>()
                    .add(CategoryManagemntGetAllEvent());
              },
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => CategoryListTile(
                        data: data[index],
                        bloc: context.read<CategoryManagementBloc>(),
                      )),
            );
          }
        }
        if (state is CategoryManagementErrorState) {
          return _centerText(state.message);
        }
        return Constants.none;
      },
    );
  }

  Center _centerText(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
  }

  CustomFloatingActionButton _floatingActionButton(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: () {
        categoryBottomSheet(context);
      },
    );
  }
}
