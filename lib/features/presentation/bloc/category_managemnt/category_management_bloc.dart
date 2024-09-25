// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/services/services.dart';

import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/category/create_category_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/category/delete_category_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/category/get_category_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/category/search_category_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/category/update_category_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/image_picker_usecase.dart';
import 'package:meta/meta.dart';

part 'category_management_event.dart';
part 'category_management_state.dart';

class CategoryManagementBloc
    extends Bloc<CategoryManagemntEvent, CategoryManagementState> {
  File? _image;
  CategoryManagementBloc() : super(CategoryManagemntInitialState()) {
    on<CategoryManagemntGetAllEvent>(categoryManagemntGetAllEvent);
    on<CategoryManagementDeleteEvent>(categoryManagementDeleteEvent);
    on<CategoryManagentCreateEvent>(categoryManagentCreateEvent);
    on<CategoryManagementImagePickerEvent>(categoryManagementImagePickerEvent);
    on<CategoryManagementEditEvent>(categoryManagementEditEvent);
    on<CategoryManagementSearchingEvent>(categoryManagementSearchingEvent);
  }
//---------------------get all---------------
  FutureOr<void> categoryManagemntGetAllEvent(
      CategoryManagemntGetAllEvent event,
      Emitter<CategoryManagementState> emit) async {
    emit(CategoryManagemntLoadingState());
    try {
      GetCategoryUsecase usecase = GetCategoryUsecase(Services.categoryRepo());
      final data = await usecase.call();
      emit(CategoryManagemntCompletedState(data));
    } catch (e) {
      emit(CategoryManagementErrorState(e.toString()));
    }
  }

//-------------------------delete------------------
  FutureOr<void> categoryManagementDeleteEvent(
      CategoryManagementDeleteEvent event,
      Emitter<CategoryManagementState> emit) async {
    try {
      DeleteCategoryUsecase usecase =
          DeleteCategoryUsecase(Services.categoryRepo());
      final result = await usecase.call(event.id, event.image);
      if (result) {
        emit(CategoryManagemntDeletionCompleted());
        add(CategoryManagemntGetAllEvent());
      }
    } catch (e) {
      emit(CategoryManagementErrorState(e.toString()));
    }
  }

//------------------------create----------------------------
  FutureOr<void> categoryManagentCreateEvent(CategoryManagentCreateEvent event,
      Emitter<CategoryManagementState> emit) async {
    if (_image == null) {
      emit(CategoryManagementErrorState(
          'Please select an image before uploading.'));
    } else {
      emit(CMUploadingToDataBaseState(_image!));
      try {
        CreateCategoryUsecase usecase =
            CreateCategoryUsecase(Services.categoryRepo());
        CategoryEntity data = CategoryEntity(
            name: event.category, image: '', id: '', file: _image);
        await usecase.call(data);
        emit(CMUploadingCompletedState('uploaded successfully'));
      } catch (e) {
        emit(CategoryManagementErrorState(e.toString()));
      }
    }
  }

//----------------------image picker---------------------
  FutureOr<void> categoryManagementImagePickerEvent(
      CategoryManagementImagePickerEvent event,
      Emitter<CategoryManagementState> emit) async {
    try {
      ImagePickerUsecase usecase = ImagePickerUsecase(Services.imageRepo());
      final image = await usecase.call(event.context);

      if (image != null) {
        _image = image;

        emit(CMImagePickerCompletedState(image));
      }
    } catch (e) {
      emit(CategoryManagementErrorState(e.toString()));
    }
  }

//---------------------edit--------------------------
  FutureOr<void> categoryManagementEditEvent(CategoryManagementEditEvent event,
      Emitter<CategoryManagementState> emit) async {
    try {
      emit(CMUploadingToDataBaseState(_image));
      UpdateCategoryUsecase usecase =
          UpdateCategoryUsecase(Services.categoryRepo());
      event.newData.file = _image;
      await usecase.call(event.id, event.newData);
      emit(CMUploadingCompletedState('edited successfully'));
      add(CategoryManagemntGetAllEvent());
    } catch (e) {
      emit(CategoryManagementErrorState(e.toString()));
    }
  }

//---------------------search---------------------
  FutureOr<void> categoryManagementSearchingEvent(
      CategoryManagementSearchingEvent event,
      Emitter<CategoryManagementState> emit) async {
    try {
      emit(CategoryManagementSearchingState());
      SearchCategoryUsecase usecase =
          SearchCategoryUsecase(Services.categoryRepo());
      final data = await usecase.call(event.querry);
      emit(CategoryManagementSearchCompletedState(data));
    } catch (e) {
      emit(CategoryManagementErrorState(e.toString()));
    }
  }
}
