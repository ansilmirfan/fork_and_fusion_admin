import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/other/filter_variables.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/widgets/filter_widget.dart';

showFilterBottomSheet(BuildContext context, ProductManagementBloc bloc,FilterVariables variables) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FilterWidget(bloc: bloc,variables: variables,);
    },
  );
}
