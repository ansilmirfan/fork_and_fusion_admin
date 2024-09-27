// ignore_for_file: unused_field

import 'dart:async';

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/services/services.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/create_product_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/delete_product_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/edit_product_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/get_products_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/products/search_product_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/image_picker_usecase.dart';

part 'product_management_event.dart';
part 'product_management_state.dart';

class ProductManagementBloc
    extends Bloc<ProductManagementEvent, ProductManagementState> {
  File? _image;
  ProductManagementBloc() : super(ProductManagementInitialState()) {
    on<ProductManagementGetAllEvent>(productManagemntGetAllEvent);
    on<ProductManagementDeleteEvent>(productManagemntDeleteEvent);
    on<ProductManagementEditEvent>(productManagemntEditEvent);
    on<ProductManagementImagePickerEvent>(productManagemntImagePickerEvent);
    on<ProductManagementSearchingEvent>(productManagemntSearchingEvent);
    on<ProductManagementCreateEvent>(productManagementCreateEvent);
  }

  //---------------------get all-------------------
  FutureOr<void> productManagemntGetAllEvent(ProductManagementGetAllEvent event,
      Emitter<ProductManagementState> emit) async {
    emit(ProductManagementLoadingState(_image, ''));
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
      ImagePickerUsecase usecase = ImagePickerUsecase(Services.imageRepo());
      final image = await usecase.call(event.context);

      if (image != null) {
        _image = image;

        emit(ProductManagementDataUpdatedState(image));
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
}
