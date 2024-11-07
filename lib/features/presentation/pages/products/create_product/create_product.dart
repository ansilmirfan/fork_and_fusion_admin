import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';

import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_selecting/category_selecting_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/other/functions.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/other/variables.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/widgets/image_widget.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/widgets/product_type_widget.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/widgets/selected_category_widget.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/create_product/widgets/textfrom_fields.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/widgets/action_selection_button.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/category_listview_bottomsheet.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/snackbar.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/textbutton.dart';

class CreateProduct extends StatelessWidget {
  ProductEntity? value;
  bool edit;
  CreateProduct({super.key, this.value, this.edit = false});
  CategorySelectingBloc categorySelectionBloc = CategorySelectingBloc();
  CreateProductVaribles variables = CreateProductVaribles();
  var gap = const SizedBox(height: 10);
  ProductManagementBloc productBloc = ProductManagementBloc();

  @override
  Widget build(BuildContext context) {
    edit
        ? categorySelectionBloc
            .add(CategoryUpdateSelectedEvent(value?.category ?? []))
        : categorySelectionBloc.add(CategorySelectingInitialEvent());
    //---------------edit true then initilise the fileds----------------
    edit ? initialiseValue() : null;

    return Scaffold(
      appBar: AppBar(title: Text(edit ? 'Edit Product' : 'Create product')),
      body: Form(
        key: Constants.product,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  _imageViewWidget(context),
                  buildTextFromFields(variables),
                  _categoryButton(context),
                  gap,
                  SelectedCategoryWidget(bloc: categorySelectionBloc),
                  gap,
                  ProductTypeWidget(selected: variables.selectedTypes)
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

//------------------------submit button-----------------------------
  BlocConsumer _submitButton() {
    return BlocConsumer<ProductManagementBloc, ProductManagementState>(
      bloc: productBloc,
      listener: (context, state) {
        if (state is ProductManagementEditCompletedState) {
          showCustomSnackbar(
              context: context, message: 'Updated successfully!');
          context
              .read<ProductManagementBloc>()
              .add(ProductManagementGetAllEvent());
          Navigator.of(context).pop();
        }
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
        if (state is ProductManagementUploadingToDataBaseState ||
            state is ProductManagementLoadingState) {
          return CustomTextButton(text: 'Uploading....', progress: true);
        }
        return CustomTextButton(
          text: 'Submit',
          onPressed: () {
            List<CategoryEntity> category =
                (categorySelectionBloc.state as CategorySelectingCompletedState)
                    .category
                    .where((e) => e.selected)
                    .toList();
            var variants = getVariants(
                variables.nameControllers, variables.priceControllers);
            List<ProductType> selectedType =
                getSelectedType(variables.selectedTypes);
            if (_validateForm(context, category, variants)) {
              ProductEntity data = ProductEntity(
                  id: edit ? value?.id ?? '' : '',
                  name: variables.nameController.text.trim().toLowerCase(),
                  image: edit ? value?.image ?? [] : [],
                  price: variables.selected.first == 'Price'
                      ? num.tryParse(variables.priceController.text.trim()) ?? 0
                      : 0,
                  ingredients: variables.ingrediantsController.text.trim(),
                  category: category,
                  offer:
                      int.tryParse(variables.offerController.text.trim()) ?? 0,
                  variants: variants,
                  type: selectedType,
                  rating: edit ? value!.rating : []);
              edit
                  ? productBloc
                      .add(ProductManagementEditEvent(value?.id ?? '', data))
                  : productBloc.add(ProductManagementCreateEvent(data));
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
        if (state is ProductManagementLoadingState) {
          return imageWidget(context,
              bloc: productBloc,
              file: state.file,
              url: state.url ?? value?.image ?? []);
        } else if (state is ProductManagementUploadingToDataBaseState) {
          return imageWidget(context, file: state.file, bloc: productBloc);
        } else if (state is ProductManagementDataUpdatedState) {
          return imageWidget(context, file: state.images, bloc: productBloc);
        }
        if (edit) {
          return imageWidget(context,
              bloc: productBloc, url: value?.image ?? []);
        }
        if (state is NodataState) {
           return imageWidget(context, image: false, bloc: productBloc);
        }

        return imageWidget(context, image: false, bloc: productBloc);
      },
    );
  }

//--------------------category button-----------------
  _categoryButton(BuildContext context) {
    return ActionSelectionButton(
        onTap: () =>
            showCategoryListViewBottomSheet(context, categorySelectionBloc),
        text: 'Category');
  }

  bool _validateForm(BuildContext context, List<CategoryEntity> category,
      Map<String, num> variants) {
    if (!Constants.product.currentState!.validate()) {
      return false;
    }

    if (variables.selected.first == 'Variants' && variants.isEmpty) {
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

  void initialiseValue() {
    variables.nameController.text = value?.name ?? '';
    if (value?.price != 0) {
      variables.priceController.text = value?.price.toString() ?? '';
    } else {
      variables.selected = {'Variants'};
      variables.nameControllers = List.generate(
        value?.variants.length ?? 0,
        (index) => TextEditingController(),
      );
      variables.priceControllers = List.generate(
        value?.variants.length ?? 0,
        (index) => TextEditingController(),
      );
      var len = value?.variants.length ?? 0;
      List keys = value?.variants.keys.toList() ?? [];
      List values = value?.variants.values.toList() ?? [];
      for (var i = 0; i < len; i++) {
        variables.priceControllers[i].text = values[i].toString();
        variables.nameControllers[i].text = keys[i];
      }
    }
    variables.ingrediantsController.text = value?.ingredients ?? '';
    if (value?.offer != 0) {
      variables.offerController.text = value?.offer.toString() ?? '';
    }
    variables.selectedTypes = List.generate(
      3,
      (index) => value?.type.contains(ProductType.values[index]) ?? false,
    );
  }
}
