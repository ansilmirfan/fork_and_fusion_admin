// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_create/category_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custome_textform_field.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/snackbar.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/textbutton.dart';

bool isScrollControled = true;
categoryBottomSheet(BuildContext context) {
  TextEditingController controller = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: isScrollControled,
    builder: (context) {
      return BlocProvider(
        create: (context) => CategoryCreateBloc(),
        child: Body(
          controller: controller,
        ),
      );
    },
  );
}

class Body extends StatelessWidget {
  TextEditingController controller;

  Body({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    var gap = const SizedBox(height: 10);
    context.read<CategoryCreateBloc>();
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
    return BlocConsumer<CategoryCreateBloc, CategoryCreatetState>(
      listener: (context, state) {
        if (state is CategoryCreateErrorState) {
          showCustomSnackbar(
              context: context, message: state.message, isSuccess: false);
        }
        if (state is UploadingCompletedState) {
          showCustomSnackbar(context: context, message: state.message);
          Navigator.of(context).pop();
        }
        if (state is UploadingToDataBaseState) {
          isScrollControled = false;
        }
      },
      builder: (context, state) {
        if (state is UploadingToDataBaseState) {
          return CustomTextButton(
            text: 'Uploading....',
            progress: true,
          );
        }
        return CustomTextButton(
          text: 'Submit',
          onPressed: () {
            if (controller.text.trim().length >= 3) {
              context
                  .read<CategoryCreateBloc>()
                  .add(UploadingToDatabaseEvent(controller.text.trim()));
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
    return BlocBuilder<CategoryCreateBloc, CategoryCreatetState>(
      builder: (context, state) {
        if (state is ImagePickerCompletedState) {
          return _buildImage(context, constraints, state.image);
        }
        if (state is UploadingToDataBaseState) {
          return _buildImage(context, constraints, state.image);
        }
        return Material(
          elevation: 10,
          borderRadius: Constants.radius,
          child: InkWell(
            onTap: () => context
                .read<CategoryCreateBloc>()
                .add(ImagePickerEvent(context)),
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
      BuildContext context, BoxConstraints constraints, File image) {
    return Material(
      elevation: 10,
      borderRadius: Constants.radius,
      child: InkWell(
        onTap: () =>
            context.read<CategoryCreateBloc>().add(ImagePickerEvent(context)),
        child: Container(
          alignment: AlignmentDirectional.center,
          height: constraints.maxHeight * .25,
          decoration:
              BoxDecoration(image: DecorationImage(image: FileImage(image))),
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
