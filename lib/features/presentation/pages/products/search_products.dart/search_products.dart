import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/debouncer.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/other/filter_variables.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/widgets/filters.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/product_tile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_eleavated_button.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_textform_field.dart';

class SearchProducts extends StatelessWidget {
  SearchProducts({super.key});
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  final TextEditingController controller = TextEditingController();
  FilterVariables variables = FilterVariables();
  ProductManagementBloc searchBloc = ProductManagementBloc();

  @override
  Widget build(BuildContext context) {
    variables.categorySelectingBloc.add(CategorySelectingInitialEvent());
    searchBloc.add(ProductManagementGetAllEvent());
    return Scaffold(
      appBar: _buildAppBar(controller),
      body: _listView(),
    );
  }

  AppBar _buildAppBar(TextEditingController controller) {
    return AppBar(
      title: SizedBox(
        height: 45,
        child: CustomTextField(
          hintText: 'Search...',
          controller: controller,
          search: true,
          action: () {
            controller.clear();
            searchBloc.add(ProductManagementGetAllEvent());
          },
          width: 1,
          onChanged: (String querry) {
            debouncer.run(
              () {
                if (querry.isEmpty) {
                  searchBloc.add(ProductManagementGetAllEvent());
                } else {
                  searchBloc.add(
                      ProductManagementSearchingEvent(querry.toLowerCase()));
                }
              },
            );
          },
        ),
      ),
    );
  }

  BlocBuilder<ProductManagementBloc, ProductManagementState> _listView() {
    return BlocBuilder<ProductManagementBloc, ProductManagementState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is ProductManagementLoadingState ||
            state is ProductManagementSearchingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductManagementSearchCompletedState) {
          if (state.data.isEmpty) {
            return _centerText('No matching products. Try a different search.');
          } else {
            return _buildListView(state.data);
          }
        } else if (state is ProductManagementCompletedState) {
          if (state.data.isEmpty) {
            return _centerText(
                'Looks like there are no products yet. Add some to get started!');
          }
          return Column(
            children: [
              Filters(
                bloc: searchBloc,
                variables: variables,
              ),
              Expanded(child: _buildListView(state.data)),
            ],
          );
        } else if (state is ProductManagementNoDataInFilter) {
          return _refresh(state);
        }
        return Constants.none;
      },
    );
  }

  Column _refresh(ProductManagementNoDataInFilter state) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              state.message,
              textAlign: TextAlign.center,
            ),
            CustomEleavatedButton(
              text: 'Refresh',
              onPressed: () {
                searchBloc.add(ProductManagementGetAllEvent());
              },
            ),
          ],
        );
  }

  RefreshIndicator _buildListView(List<ProductEntity> data) {
    return RefreshIndicator(
      onRefresh: () async {
        searchBloc.add(ProductManagementGetAllEvent());
      },
      child: ListView.builder(
          padding: Constants.padding10,
          itemCount: data.length,
          itemBuilder: (context, index) =>
              ProductTile(data: data[index], search: true)),
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
}
