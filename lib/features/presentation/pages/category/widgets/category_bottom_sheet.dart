// ignore_for_file: must_be_immutable


import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';

import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custome_textform_field.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/pop.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/snackbar.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/textbutton.dart';

categoryBottomSheet(
  BuildContext context, {
  bool edit = false,
  CategoryEntity? data,
}) {
  TextEditingController controller = TextEditingController();
  CategoryManagementBloc bloc = CategoryManagementBloc();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) {
      return Body(
        controller: controller,
        edit: edit,
        data: data,
        bloc: bloc,
      );
    },
  );
}

class Body extends StatelessWidget {
  TextEditingController controller;
  CategoryManagementBloc bloc;
  bool edit;
  CategoryEntity? data;
  Body(
      {super.key,
      required this.controller,
      required this.edit,
      this.data,
      required this.bloc});

  @override
  Widget build(BuildContext context) {
    edit ? controller.text = data?.name ?? '' : null;

    var gap = const SizedBox(height: 10);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: Constants.padding10,
              margin: Constants.padding10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 223, 220, 220),
                borderRadius: Constants.radius,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  gap,
                  _titleText(context),
                  gap,
                  _textFormField(controller),
                  gap,
                  _image(constraints, context),
                  gap,
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BlocConsumer _buildSubmitButton(BuildContext context) {
    return BlocConsumer<CategoryManagementBloc, CategoryManagementState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is CategoryManagementErrorState) {
          showCustomSnackbar(
              context: context, message: state.message, isSuccess: false);
        }
        if (state is CMUploadingCompletedState) {
          showCustomSnackbar(context: context, message: state.message);
       
          context
              .read<CategoryManagementBloc>()
              .add(CategoryManagemntGetAllEvent());
          pop(context);
        }
      },
      builder: (context, state) {
        if (state is CMUploadingToDataBaseState) {
          return CustomTextButton(
            text: 'Uploading....',
            progress: true,
          );
        }
        return CustomTextButton(
          text: 'Submit',
          onPressed: () {
            if (controller.text.trim().length >= 3) {
              edit
                  ? bloc.add(CategoryManagementEditEvent(
                      data!.id,
                      CategoryEntity(
                          name: controller.text.trim(),
                          image: data!.image,
                          id: data!.id)))
                  : bloc
                      .add(CategoryManagentCreateEvent(controller.text.trim()));
            } else {
              showCustomSnackbar(
                context: context,
                message: 'Category name must be at least 3 characters long.',
                isSuccess: false,
              );
            }
          },
        );
      },
    );
  }

  BlocBuilder _image(BoxConstraints constraints, BuildContext context) {
    return BlocBuilder<CategoryManagementBloc, CategoryManagementState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is CMImagePickerCompletedState) {
          return _buildImage(
              context: context, constraints: constraints, image: state.image);
        }
        if (state is CMUploadingToDataBaseState) {
          return _buildImage(
              context: context, constraints: constraints, image: state.image);
        }
        if (edit) {
          return _buildImage(
              context: context,
              constraints: constraints,
              url: data?.image ?? '');
        }
        return Material(
          elevation: 10,
          borderRadius: Constants.radius,
          child: InkWell(
            onTap: () => bloc.add(CategoryManagementImagePickerEvent(context)),
            child: Container(
              alignment: AlignmentDirectional.center,
              height: constraints.maxHeight * .25,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo,
                    size: 60,
                  ),
                  Text('Click here to add image')
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Material _buildImage(
      {required BuildContext context,
      required BoxConstraints constraints,
      File? image,
      String url = ''}) {
    return Material(
      elevation: 10,
      borderRadius: Constants.radius,
      child: InkWell(
        onTap: () => bloc.add(CategoryManagementImagePickerEvent(context)),
        child: Container(
          alignment: AlignmentDirectional.center,
          height: constraints.maxHeight * .25,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: image == null
                      ? CachedNetworkImageProvider(url)
                      : FileImage(image))),
        ),
      ),
    );
  }

  CustomeTextField _textFormField(TextEditingController controller) {
    return CustomeTextField(
      hintText: 'Category',
      validator: Validation.validateCategory,
      controller: controller,
    );
  }

  Text _titleText(BuildContext context) {
    return Text(
      'Category',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
