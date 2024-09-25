import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/product_tile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/floating_action_button.dart';

class Products extends StatelessWidget {
  Products({super.key});
  var type = ProductType.values;

  @override
  Widget build(BuildContext context) {
    context.read<ProductManagementBloc>().add(ProductManagementGetAllEvent());
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: const CustomDrawer(),
        body: TabBarView(
          children:
              List.generate(4, (index) => _buildProductsListView(index - 1)),
        ),
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Products'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/product search');
          },
          icon: const Icon(Icons.search),
        )
      ],
      bottom: TabBar(
        dividerHeight: 0.0,
        isScrollable: true,
        unselectedLabelColor: Theme.of(context).colorScheme.tertiary,
        indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: Constants.radius),
        tabs: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(index == 0
                ? "All"
                : Utils.removeAndCapitalize(type[index - 1].name)),
          ),
        ),
      ),
    );
  }

  Padding _buildProductsListView(int index) {
    return Padding(
      padding: Constants.padding10,
      child: BlocBuilder<ProductManagementBloc, ProductManagementState>(
        builder: (context, state) {
          if (state is ProductManagementLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductManagementCompletedState) {
            var data = state.data;
            index == -1
                ? null
                : data = data
                    .where((ProductEntity e) => e.type.contains(type[index]))
                    .toList();
            if (data.isEmpty) {
              return _centerText(
                  'Looks like there are no products yet. Add some to get started!');
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => ProductTile(data: data[index]),
            );
          }
          if (state is ProductManagementErrorState) {
            return _centerText(state.message);
          }
          return Constants.none;
        },
      ),
    );
  }

  Center _centerText(String text) {
    return Center(
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  CustomFloatingActionButton _floatingActionButton(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: () {
        CategorySelectingBloc bloc = CategorySelectingBloc();
        bloc.add(CategorySelectingInitialEvent());
        Navigator.of(context).pushNamed('/create product', arguments: bloc);
      },
    );
  }
}
