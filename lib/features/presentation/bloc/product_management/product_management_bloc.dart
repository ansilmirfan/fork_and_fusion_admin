// ignore_for_file: unused_field

import 'dart:async';
import 'dart:developer';

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/services/services.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/create_product_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/delete_product_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/edit_product_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/get_products_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/search_product_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/image_usecase/pick_multiple_image_usecase.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/products/search_products.dart/other/functions.dart';

part 'product_management_event.dart';
part 'product_management_state.dart';

class ProductManagementBloc
    extends Bloc<ProductManagementEvent, ProductManagementState> {
  List<File?>? _image;
  ProductManagementBloc() : super(ProductManagementInitialState()) {
    on<ProductManagementGetAllEvent>(productManagemntGetAllEvent);
    on<ProductManagementDeleteEvent>(productManagemntDeleteEvent);
    on<ProductManagementEditEvent>(productManagemntEditEvent);
    on<ProductManagementImagePickerEvent>(productManagemntImagePickerEvent);
    on<ProductManagementSearchingEvent>(productManagemntSearchingEvent);
    on<ProductManagementCreateEvent>(productManagementCreateEvent);
    on<ProductManagementFilterEvent>(productManagementFilterEvent);
  }

  //---------------------get all-------------------
  FutureOr<void> productManagemntGetAllEvent(ProductManagementGetAllEvent event,
      Emitter<ProductManagementState> emit) async {
    emit(ProductManagementLoadingState(_image, const []));
    try {
      GetProductsUsecase usecase = GetProductsUsecase(Services.productRepo());
      final data = await usecase.call();
      emit(ProductManagementCompletedState(data));
    } catch (e) {
      emit(ProductManagementErrorState(e.toString()));
    }
  }

//----------------search-------------
  FutureOr<void> productManagemntSearchingEvent(
      ProductManagementSearchingEvent event,
      Emitter<ProductManagementState> emit) async {
    emit(ProductManagementSearchingState());
    try {
      SearchProductUsecase usecase =
          SearchProductUsecase(Services.productRepo());
      final data = await usecase.call(event.querry);
      emit(ProductManagementSearchCompletedState(data));
    } catch (e) {
      emit(ProductManagementErrorState(e.toString()));
    }
  }

//-----------------delete-----------------------
  FutureOr<void> productManagemntDeleteEvent(ProductManagementDeleteEvent event,
      Emitter<ProductManagementState> emit) async {
    try {
      DeleteProductUsecase usecase =
          DeleteProductUsecase(Services.productRepo());
      final response = await usecase.call(event.id, event.image);
      if (response) {
        emit(ProductManagementDeleteCompletedState());
        add(ProductManagementGetAllEvent());
      }
    } catch (e) {
      emit(ProductManagementErrorState(e.toString()));
    }
  }

//-----------------------edit------------------
  FutureOr<void> productManagemntEditEvent(ProductManagementEditEvent event,
      Emitter<ProductManagementState> emit) async {
    event.newData.file = _image;
    emit(ProductManagementLoadingState(_image, event.newData.image));
    try {
      EditProductUsecase usecase = EditProductUsecase(Services.productRepo());
      final response = await usecase.call(event.id, event.newData);
      if (response) {
        emit(ProductManagementEditCompletedState());
        add(ProductManagementGetAllEvent());
      }
    } catch (e) {
      emit(ProductManagementErrorState(e.toString()));
    }
  }

//-----------------------image picker------------
  FutureOr<void> productManagemntImagePickerEvent(
      ProductManagementImagePickerEvent event,
      Emitter<ProductManagementState> emit) async {
    try {
      PickMultipleImageUsecase usecase =
          PickMultipleImageUsecase(Services.imageRepo());
      final image = await usecase.call(event.context);

      if (image != null) {
        _image = image;

        emit(ProductManagementDataUpdatedState(image));
      } else {
        emit(NodataState());
      }
    } catch (e) {
      emit(ProductManagementErrorState(e.toString()));
    }
  }

//------------------------create----------------------
  FutureOr<void> productManagementCreateEvent(
      ProductManagementCreateEvent event,
      Emitter<ProductManagementState> emit) async {
    if (_image == null) {
      emit(ProductManagementErrorState(
          'Please select an image before submitting.'));
    } else {
      emit(ProductManagementUploadingToDataBaseState(_image!));
      try {
        CreateProductUsecase usecase =
            CreateProductUsecase(Services.productRepo());
        ProductEntity data = event.data;
        data.file = _image;
        await usecase.call(data);
        emit(ProductManagementUploadingCompletedState('uploaded successfully'));
      } catch (e) {
        emit(ProductManagementErrorState(e.toString()));
      }
    }
  }

  FutureOr<void> productManagementFilterEvent(
      ProductManagementFilterEvent event,
      Emitter<ProductManagementState> emit) async {
    try {
      emit(ProductManagementLoadingState(_image, const []));
      GetProductsUsecase usecase = GetProductsUsecase(Services.productRepo());
      var data = await usecase.call();

      //--------filter by category-----------
      data = data.where((e) {
        var selectedCategory = event.selectedCategory.map((e) => e.id);
        return e.category.any((e) => selectedCategory.contains(e.id));
      }).toList();

      //----------filter by price range-----------
      data = data.where((e) {
        num price =
            e.price == 0 ? _extractMin(e.variants.values.toList()) : e.price;
        log('$price');
        return price >= event.rangeValues.start.toInt() &&
            price < event.rangeValues.end.toInt();
      }).toList();
      log('filter by range  ${data.length}');
      //-----------filter by name-----------
      if (event.nameState == FilterStates.asc) {
        data.sort((a, b) => b.name.compareTo(a.name));
      } else if (event.nameState == FilterStates.dsc) {
        data.sort((a, b) => a.name.compareTo(b.name));
      }
      if (event.priceState == FilterStates.asc) {
        data = sortByPrice(data, true);
      } else if (event.priceState == FilterStates.dsc) {
        data = sortByPrice(data, false);
      }
      if (data.isEmpty) {
        emit(ProductManagementNoDataInFilter());
      } else {
        emit(ProductManagementCompletedState(data));
      }
    } catch (e) {
      emit(ProductManagementErrorState(e.toString()));
    }
  }

  num _extractMin(List<dynamic> data) {
    return data
        .map((e) => e is String ? int.parse(e) : e)
        .toList()
        .reduce((a, b) => a < b ? a : b);
  }

  List<ProductEntity> sortByPrice(List<ProductEntity> data, bool isAsc) {
    data.sort((a, b) {
      num pa = a.price == 0
          ? a.variants.values
              .map((e) => e is String ? int.parse(e) : e)
              .toList()
              .reduce((a, b) => a < b ? a : b)
          : a.price;
      num pb = b.price == 0
          ? b.variants.values
              .map((e) => e is String ? int.parse(e) : e)
              .toList()
              .reduce((a, b) => a < b ? a : b)
          : b.price;
      return pa.compareTo(pb);
    });
    if (isAsc) {
      return data;
    }
    return data.reversed.toList();
  }
}
