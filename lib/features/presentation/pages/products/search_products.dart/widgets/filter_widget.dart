import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/other/filter_variables.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/other/functions.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/action_selection_button.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/category_listview_bottomsheet.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/textbutton.dart';

class FilterWidget extends StatelessWidget {
  final ProductManagementBloc bloc;
  FilterVariables variables;

  FilterWidget({super.key, required this.bloc, required this.variables});

  var gap = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: Constants.padding10,
          child: Container(
            width: double.infinity,
            padding: Constants.padding15,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 208, 208, 208),
              borderRadius: Constants.radius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCategory(context, variables.categorySelectingBloc),
                gap,
                _buildSlider(setState),
                gap,
                _buildSort(setState, variables.nameState, variables.priceState),
                gap,
                _applyButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  CustomTextButton _applyButton(BuildContext context) {
    return CustomTextButton(
      text: 'Apply',
      onPressed: () {
        List<CategoryEntity> category = (variables.categorySelectingBloc.state
                as CategorySelectingCompletedState)
            .category;
        var selected = category.where((e) => e.selected).toList();
        if (selected.isEmpty) {
          for (var element in category) {
            element.selected = true;
          }
        }

        bloc.add(ProductManagementFilterEvent(
            nameState: variables.nameState,
            priceState: variables.priceState,
            rangeValues: variables.rangeValues,
            selectedCategory: selected.isEmpty ? category : selected));
        Navigator.of(context).pop();
      },
    );
  }

  ActionSelectionButton _buildCategory(
      BuildContext context, CategorySelectingBloc categorySelectingBloc) {
    return ActionSelectionButton(
      onTap: () {
        showCategoryListViewBottomSheet(context, categorySelectingBloc);
      },
      text: 'Category',
    );
  }

  Material _buildSlider(StateSetter setState) {
    return Material(
      borderRadius: Constants.radius,
      elevation: 10,
      child: Container(
        padding: Constants.padding10,
        child: Column(
          children: [
            const Text('Price'),
            const SizedBox(height: 10),
            // Range Slider
            RangeSlider(
              min: 0,
              max: 10000,
              divisions: 500,
              labels: RangeLabels(
                '${variables.rangeValues.start.toInt()}',
                '${variables.rangeValues.end.toInt()}',
              ),
              values: variables.rangeValues,
              onChanged: (value) {
                setState(() => variables.rangeValues = value);
              },
            ),
            Row(
              children: [
                _selectedValue(variables.rangeValues.start.toInt().toString()),
                const Text('   -   '),
                _selectedValue(variables.rangeValues.end.toInt().toString()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded _selectedValue(String value) {
    return Expanded(
      child: Material(
        borderRadius: Constants.radius,
        elevation: 10,
        child: Container(
          alignment: Alignment.center,
          padding: Constants.padding10,
          child: Text(value),
        ),
      ),
    );
  }

  Material _buildSort(
      StateSetter setState, FilterStates nameState, FilterStates priceState) {
    return Material(
      borderRadius: Constants.radius,
      elevation: 10,
      child: Container(
        padding: Constants.padding10,
        child: Column(
          children: [
            const Text('Sort'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _sortButton(setState, 'Price', true),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _sortButton(setState, 'Name', false),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Material _sortButton(
    StateSetter setState,
    String name,
    bool isNameSort,
  ) {
    return Material(
      elevation: 10,
      borderRadius: Constants.radius,
      child: InkWell(
        borderRadius: Constants.radius,
        onTap: () {
          setState(() {
            if (isNameSort) {
              variables.nameState =
                  FilterUtils.getNextState(variables.nameState);
              variables.priceState = FilterStates.initial;
            } else {
              variables.priceState =
                  FilterUtils.getNextState(variables.priceState);
              variables.nameState = FilterStates.initial;
            }
          });
        },
        child: Padding(
          padding: Constants.padding10,
          child: Row(
            children: [
              Text(name),
              const Spacer(),
              isNameSort
                  ? FilterUtils.getIcon(variables.nameState)
                  : FilterUtils.getIcon(variables.priceState),
            ],
          ),
        ),
      ),
    );
  }
}
