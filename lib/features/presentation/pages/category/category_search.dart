import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_listtile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custome_textform_field.dart';

class CategorySearch extends StatelessWidget {
  CategorySearch({super.key});

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CategoryManagementBloc bloc = CategoryManagementBloc();
    bloc.add(CategoryManagemntGetAllEvent());
    return Scaffold(
      appBar: _buildAppBar(bloc),
      body: BlocBuilder<CategoryManagementBloc, CategoryManagementState>(
        bloc: bloc,
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
      ),
    );
  }

  ListView _buildListView(List<CategoryEntity> data) {
    return ListView.builder(
      padding: Constants.padding10,
      itemCount: data.length,
      itemBuilder: (context, index) => CategoryListtile(data: data[index]),
    );
  }

  Padding _centerText(String text) {
    return Padding(
      padding: Constants.padding10,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  AppBar _buildAppBar(CategoryManagementBloc bloc) {
    return AppBar(
      title: SizedBox(
        height: 45,
        child: CustomeTextField(
          hintText: 'Search...',
          controller: controller,
          search: true,
          suffixIcon: true,
          width: 1,
          onChanged: (String querry) {
            querry.isEmpty
                ? bloc.add(CategoryManagemntGetAllEvent())
                : bloc.add(CategoryManagementSearchingEvent(querry.toLowerCase()));
          },
        ),
      ),
    );
  }
}
