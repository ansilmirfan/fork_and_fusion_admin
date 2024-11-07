import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/other/functions.dart';

class FilterVariables{
  FilterStates nameState = FilterStates.initial;
  FilterStates priceState = FilterStates.initial;
  RangeValues rangeValues = const RangeValues(20, 1200);
  CategorySelectingBloc categorySelectingBloc = CategorySelectingBloc();
}