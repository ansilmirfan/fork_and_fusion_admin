import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';

import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/widgets/product_type_widget.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/action_selection_button.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/category_listview_bottomSheet.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/segemnted_button.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/variants_widget.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/cached_image.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_textform_field.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/snackbar.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/textbutton.dart';

class CreateProduct extends StatelessWidget {
  CategorySelectingBloc selectionBloc;
  CreateProduct({super.key, required this.selectionBloc});
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  List<bool> selectedTypes = List.generate(4, (index) => index == 2);
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> priceControllers = [];
  TextEditingController ingrediantsController = TextEditingController();
  var gap = const SizedBox(height: 10);
  Set<String> selected = {'Price'};
  ProductManagementBloc productBloc = ProductManagementBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create product')),
      body: Form(
        key: Constants.product,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  _imageViewWidget(context),
                  _buildTextFormFields(),
                  _categoryButton(context),
                  gap,
                  _buildSelectedCategory(),
                  gap,
                  ProductTypeWidget(selected: selectedTypes)
                ],
              ),
            ),
            _submitButton(),
            gap,
          ],
        ),
      ),
    );
  }

//-----------------selected category---------------------
  BlocBuilder<CategorySelectingBloc, CategorySelectingState>
      _buildSelectedCategory() {
    return BlocBuilder<CategorySelectingBloc, CategorySelectingState>(
        bloc: selectionBloc,
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
                      selectionBloc.add(CategoryDisSelectEvent(data[index].id)),
                  deleteIcon: const Icon(Icons.close),
                ),
              ),
            );
          }
          return Constants.none;
        });
  }

//------------------------submit button-----------------------------
  BlocConsumer _submitButton() {
    return BlocConsumer<ProductManagementBloc, ProductManagementState>(
      bloc: productBloc,
      listener: (context, state) {
        if (state is ProductManagementUploadingCompletedState) {
          showCustomSnackbar(context: context, message: state.message);
          context
              .read<ProductManagementBloc>()
              .add(ProductManagementGetAllEvent());
         Navigator.of(context).pop();
        }
        if (state is ProductManagementErrorState) {
          showCustomSnackbar(
              context: context, message: state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        if (state is ProductManagementUploadingToDataBaseState) {
          return CustomTextButton(text: 'Uploading....', progress: true);
        }
        return CustomTextButton(
          text: 'Submit',
          onPressed: () {
            List<CategoryEntity> category =
                (selectionBloc.state as CategorySelectingCompletedState)
                    .category
                    .where((e) => e.selected)
                    .toList();
            var variants = getVariants();
            List<ProductType> selectedType = getSelectedType(selectedTypes);
            if (_validateForm(context, category, variants)) {
              ProductEntity data = ProductEntity(
                id: '',
                name: nameController.text.trim().toLowerCase(),
                image: '',
                price: num.tryParse(priceController.text.trim()) ?? 0,
                ingredients: ingrediantsController.text.trim(),
                category: category,
                offer: int.tryParse(offerController.text.trim()) ?? 0,
                variants: variants,
                type: selectedType,
              );
              productBloc.add(ProductManagementCreateEvent(data));
            }
          },
        );
      },
    );
  }

//--------------------------------image view widget--------------
  BlocBuilder _imageViewWidget(BuildContext context) {
    return BlocBuilder<ProductManagementBloc, ProductManagementState>(
      bloc: productBloc,
      builder: (context, state) {
        if (state is ProductManagementDataUpdatedState) {
          return _buildImage(context, file: state.image);
        }
        if (state is ProductManagementUploadingToDataBaseState) {
          return _buildImage(context, file: state.image);
        }
        if (state is ProductManagementUploadingToDataBaseState) {
          return _buildImage(context, file: state.image);
        }
        return _buildImage(context, image: false);
      },
    );
  }

//-----------------------image-------------------------
  Material _buildImage(BuildContext context,
      {bool image = true,
      bool netWorkImage = false,
      String url = '',
      File? file}) {
    return Material(
      elevation: 10,
      borderRadius: Constants.radius,
      child: InkWell(
        onTap: () {
          productBloc.add(ProductManagementImagePickerEvent(context));
        },
        child: Container(
          alignment: AlignmentDirectional.center,
          height: Constants.dHeight * .25,
          child: image
              ? netWorkImage
                  ? CachedImage(url: url)
                  : Image.file(file!)
              : const Column(
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
  }

//--------------------category button-----------------
  _categoryButton(BuildContext context) {
    return ActionSelectionButton(
        onTap: () => showCategoryListViewBottomSheet(context, selectionBloc),
        text: 'Category');
  }

//-------------------textfform fields--------------
  Column _buildTextFormFields() {
    return Column(
      children: [
        gap,
        CustomTextField(
          hintText: 'Product Name',
          validator: (querry) {
            return Validation.validateName(querry,
                minLength: 3, name: 'product name');
          },
          controller: nameController,
          width: 1,
        ),
        gap,
        CustomTextField(
          hintText: 'Ingrediants',
          maxLength: 250,
          validator: (querry) {
            return Validation.validateName(querry,
                minLength: 10, name: 'Ingrediants');
          },
          controller: ingrediantsController,
          width: 1,
          multiLine: 6,
        ),
        gap,
        StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              CustomSegementedButton(
                selected: selected,
                onSelectionChanged: (s) => setState(() => selected = s),
              ),
              gap,
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: selected.first == 'Price'
                    ? CustomTextField(
                        hintText: 'Price',
                        validator: (querry) {
                          return Validation.validateNumber(querry,
                              minValue: 2, name: 'price');
                        },
                        maxLength: 5,
                        controller: priceController,
                        width: 1,
                        keyboardType: TextInputType.number,
                      )
                    : VariantSelection(
                        nameControllers: nameControllers,
                        priceControllers: priceControllers),
              ),
            ],
          ),
        ),
        gap,
        CustomTextField(
          hintText: 'Offer',
          maxLength: 2,
          validator: (querry) {
            return Validation.validatePercentage(querry);
          },
          controller: offerController,
          helperText: '% 1-99',
          width: 1,
        ),
        gap,
      ],
    );
  }

  bool _validateForm(BuildContext context, List<CategoryEntity> category,
      Map<String, num> variants) {
    if (!Constants.product.currentState!.validate()) {
      return false;
    }

    if (selected.first == 'Variants' && variants.isEmpty) {
      showCustomSnackbar(
        context: context,
        message: 'Variants cannot be empty. Please add at least one.',
        isSuccess: false,
      );
      return false;
    }

    if (category.isEmpty) {
      showCustomSnackbar(
        context: context,
        message: 'Category cannot be empty! Select at least one category.',
        isSuccess: false,
      );
      return false;
    }

    return true;
  }

  Map<String, num> getVariants() {
    Map<String, num> varints = {};
    for (var i = 0; i < nameControllers.length; i++) {
      varints[nameControllers[i].text.trim()] =
          num.parse(priceControllers[i].text.trim());
    }
    return varints;
  }

  List<ProductType> getSelectedType(List<bool> selected) {
    List<ProductType> type = [];
    for (var i = 0; i < 3; i++) {
      if (selected[i]) {
        type.add(ProductType.values[i]);
      }
    }
    return type;
  }
}
