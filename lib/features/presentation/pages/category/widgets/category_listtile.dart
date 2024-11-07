// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_management_bloc.dart';

import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_bottom_sheet.dart';

import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_alert_dialog.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/custome_circle_avathar.dart';

class CategoryListTile extends StatelessWidget {
  CategoryEntity data;
  CategoryManagementBloc? bloc;
  bool search;

  CategoryListTile(
      {super.key, required this.data, this.bloc, this.search = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Hero(
        tag: data.name,
        child: Material(
          borderRadius: Constants.radius,
          elevation: 10,
          child: ListTile(
            onTap: () => onTap(context),
            leading: _buildImage(),
            title: Text(Utils.capitalizeEachWord(data.name)),
            trailing: _buildTrailingButtons(context),
          ),
        ),
      ),
    );
  }

  Row _buildTrailingButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //--------------edit button----------------
        IconButton(
          onPressed: () {
            categoryBottomSheet(context,
                edit: true, data: data, categoryBloc: search ? bloc : null);
          },
          icon: const Icon(Icons.edit),
        ),
        //----------------------delete button----------------
        IconButton(
          onPressed: () {
            showCustomAlertDialog(
              context: context,
              title: 'Confirm Deletion',
              description:
                  'This action will permanently remove this item. Do you want to proceed?',
              okbutton: _okButton(bloc),
            );
          },
          icon: const Icon(Icons.delete),
        )
      ],
    );
  }

//-------------------ok button for alert dialog-------------------
  BlocConsumer _okButton(CategoryManagementBloc? bloc) {
    CategoryManagementBloc categoryManagementBloc = CategoryManagementBloc();
    return BlocConsumer<CategoryManagementBloc, CategoryManagementState>(
      bloc: categoryManagementBloc,
      listener: (context, state) {
        if (state is CategoryManagemntDeletionCompleted) {
          if (search) {
            context
                .read<CategoryManagementBloc>()
                .add(CategoryManagemntGetAllEvent());
          }
          bloc?.add(CategoryManagemntGetAllEvent());

          Navigator.of(context).pop();
        }
        if (state is CategoryManagementErrorState) {
          Navigator.of(context).pop();
          showCustomAlertDialog(
              context: context,
              title: 'Error!',
              description: state.message,
              error: true);
        }
      },
      builder: (context, state) {
        if (state is CategoryManagemntLoadingState) {
          return const ElevatedButton(
              onPressed: null, child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: () {
            categoryManagementBloc
                .add(CategoryManagementDeleteEvent(data.id, data.image));
          },
          child: const Text('OK'),
        );
      },
    );
  }

  _buildImage() {
    return CustomeCircleAvathar(url: data.image);
  }

  void onTap(BuildContext context) {
    Navigator.of(context).pushNamed('/category details', arguments: data);
  }
}
