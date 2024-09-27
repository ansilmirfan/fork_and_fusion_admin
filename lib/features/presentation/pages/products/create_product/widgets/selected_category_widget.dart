import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';

class SelectedCategoryWidget extends StatelessWidget {
  final CategorySelectingBloc bloc;
  const SelectedCategoryWidget({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorySelectingBloc, CategorySelectingState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is CategorySelectingCompletedState) {
            var data = state.category;
            data = data.where((e) => e.selected).toList();
            return Wrap(
              spacing: 10,
              children: List.generate(
                data.length,
                (index) => InputChip(
                  label: Text(
                    data[index].name,
                  ),
                  onDeleted: () =>
                      bloc.add(CategoryDisSelectEvent(data[index].id)),
                  deleteIcon: const Icon(Icons.close),
                ),
              ),
            );
          }
          return Constants.none;
        });
  }
}
