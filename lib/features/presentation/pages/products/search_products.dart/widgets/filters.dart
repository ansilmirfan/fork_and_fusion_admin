import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/other/filter_variables.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/widgets/filter_bottom_sheet.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/square_icon_button.dart';

class Filters extends StatelessWidget {
  final ProductManagementBloc bloc;
  FilterVariables variables;

  Filters({super.key, required this.bloc, required this.variables});

  final gap = const SizedBox(width: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.padding10,
      child: Row(
        children: [
          const Spacer(),
          SquareIconButton(
            icon: Icons.filter_list,
            onTap: () => showFilterBottomSheet(context, bloc, variables),
          ),
        ],
      ),
    );
  }
}
