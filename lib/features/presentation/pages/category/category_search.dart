import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/debouncer.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_listtile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_textform_field.dart';

class CategorySearch extends StatelessWidget {
  CategorySearch({super.key});

  CategoryManagementBloc bloc = CategoryManagementBloc();
  Debouncer debouncer = Debouncer(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    bloc.add(CategoryManagemntGetAllEvent());
    return Scaffold(
      appBar: _buildAppBar(bloc, controller),
      body: _listView(bloc),
    );
  }

  BlocBuilder<CategoryManagementBloc, CategoryManagementState> _listView(
      CategoryManagementBloc bloc) {
    return BlocBuilder<CategoryManagementBloc, CategoryManagementState>(
      bloc: bloc,
      buildWhen: (previous, current) {
        return current is CategoryManagemntCompletedState ||
            current is CategoryManagementSearchCompletedState ||
            current is CategoryManagementSearchingState;
      },
      builder: (context, state) {
        if (state is CategoryManagemntCompletedState) {
          if (state.data.isEmpty) {
            return _centerText(
                'Looks like there are no categories yet. Add some to get started!');
          }
          return _buildListView(state.data);
        }
        if (state is CategoryManagementSearchingState ||
            state is CategoryManagemntLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CategoryManagementSearchCompletedState) {
          if (state.data.isEmpty) {
            return _centerText(
                'No matching categories. Try a different search.');
          }
          return _buildListView(state.data);
        }
        return Constants.none;
      },
    );
  }

  ListView _buildListView(List<CategoryEntity> data) {
    return ListView.builder(
      padding: Constants.padding10,
      itemCount: data.length,
      itemBuilder: (context, index) => CategoryListTile(
        data: data[index],
        bloc: bloc,
        search: true,
      ),
    );
  }

  Padding _centerText(String text) {
    return Padding(
      padding: Constants.padding10,
      child: Center(
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  AppBar _buildAppBar(
      CategoryManagementBloc bloc, TextEditingController controller) {
    return AppBar(
      title: SizedBox(
        height: 45,
        child: CustomTextField(
          hintText: 'Search...',
          controller: controller,
          search: true,
          action: () {
            controller.clear();
            bloc.add(CategoryManagemntGetAllEvent());
          },
          width: 1,
          onChanged: (String query) {
            debouncer.run(
              () {
                if (query.isEmpty) {
                  bloc.add(CategoryManagemntGetAllEvent());
                } else {
                  bloc.add(
                      CategoryManagementSearchingEvent(query.toLowerCase()));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
