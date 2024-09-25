
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/custome_circle_avathar.dart';

import 'package:fork_and_fusion_admin/features/presentation/widgets/textbutton.dart';

showCategoryListViewBottomSheet(
    BuildContext context, CategorySelectingBloc bloc) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        snap: true,
        builder: (context, scrollController) {
          return Padding(
            padding: Constants.padding10,
            child: Container(
              padding: Constants.padding10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 239, 239),
                borderRadius: Constants.radius,
              ),
              child: _buildListView(bloc, scrollController),
            ),
          );
        },
      );
    },
  );
}

BlocBuilder<CategorySelectingBloc, CategorySelectingState> _buildListView(
    CategorySelectingBloc bloc, ScrollController scrollController) {
  return BlocBuilder<CategorySelectingBloc, CategorySelectingState>(
    bloc: bloc,
    builder: (context, state) {
      if (state is CategorySelectingLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is CategorySelectingCompletedState) {
        return listView(state, scrollController, bloc, context);
      }
      return const Center(
        child: Text('Please check the Internet'),
      );
    },
  );
}

Column listView(
    CategorySelectingCompletedState state,
    ScrollController scrollController,
    CategorySelectingBloc bloc,
    BuildContext context) {
  return Column(
    children: [
      _buildSelectedCountAndpopButton(state, context),
      Expanded(
        child: ListView.builder(
          itemCount: state.category.length,
          controller: scrollController,
          itemBuilder: (context, index) =>
              _buildListTile(state.category[index], index, bloc, context),
        ),
      ),
      CustomTextButton(
        text: 'Submit',
        onPressed: () => Navigator.of(context).pop(),
      )
    ],
  );
}

Row _buildSelectedCountAndpopButton(
    CategorySelectingCompletedState state, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "    ${selectedCount(state.category)}  Selected",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      IconButton(
          onPressed: () {
           Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close))
    ],
  );
}

String selectedCount(List<CategoryEntity> data) {
  if (data.isEmpty) {
    return '0';
  }
  return data.where((e) => e.selected).length.toString();
}

Padding _buildListTile(CategoryEntity data, int index,
    CategorySelectingBloc bloc, BuildContext context) {
  return Padding(
    padding: Constants.padding10,
    child: Material(
      color: Theme.of(context).colorScheme.tertiary,
      borderRadius: Constants.radius,
      elevation: 10,
      child: CheckboxListTile(
        selectedTileColor: Theme.of(context).secondaryHeaderColor,
        title: Row(
          children: [
            CustomeCircleAvathar(url: data.image),
            const SizedBox(width: 10),
            Text(Utils.capitalizeEachWord(data.name)),
          ],
        ),
        value: data.selected,
        onChanged: (value) {
          bloc.add(CategorySelectingChangedEvent(index));
        },
      ),
    ),
  );
}
