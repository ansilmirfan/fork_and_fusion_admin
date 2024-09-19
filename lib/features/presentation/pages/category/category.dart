import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_managemnt_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/category_bottom_sheet.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/floating_action_button.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryManagemntBloc>().add(CategoryManagemntGetAllEvent());
    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: Constants.padding10,
        child: _buildListView(),
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  BlocBuilder<CategoryManagemntBloc, CategoryManagemntState> _buildListView() {
    return BlocBuilder<CategoryManagemntBloc, CategoryManagemntState>(
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
                    .read<CategoryManagemntBloc>()
                    .add(CategoryManagemntGetAllEvent());
              },
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    borderRadius: Constants.radius,
                    elevation: 10,
                    child: ListTile(
                     
                      onTap: () {},
                      title: Text(data[index].name),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        if (state is CategoryManagemntErrorState) {
          return _centerText(state.message);
        }
        return Constants.none;
      },
    );
  }

  Center _centerText(String message) {
    return Center(
      child: Text(message),
    );
  }

  CustomFloatingActionButton _floatingActionButton(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: () => categoryBottomSheet(context),
    );
  }
}
