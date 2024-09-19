// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/services/services.dart';
import 'package:fork_and_fusion_admin/features/data/repository/image_repository.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/category/create_category_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/image_picker_usecase.dart';

part 'category_management_event.dart';
part 'category_management_state.dart';

class CategoryCreateBloc
    extends Bloc<CategoryCreateEvent, CategoryCreatetState> {
  File? _image;
  CategoryCreateBloc() : super(CategoryCreateInitialState()) {
    on<ImagePickerEvent>(imagePickerEvent);
    on<UploadingToDatabaseEvent>(uploadingToDatabaseEvent);
  }

  FutureOr<void> imagePickerEvent(
      ImagePickerEvent event, Emitter<CategoryCreatetState> emit) async {
    try {
      ImageRepository repo = ImageRepository();
      ImagePickerUsecase usecase = ImagePickerUsecase(repo);
      final image = await usecase.call(event.context);
      if (image != null) {
        _image = image;
        emit(ImagePickerCompletedState(image));
      } else {
        emit(CategoryCreateErrorState('Something went wrong!'));
      }
    } catch (e) {
      emit(CategoryCreateErrorState('Something went wrong!'));
    }
  }

  FutureOr<void> uploadingToDatabaseEvent(UploadingToDatabaseEvent event,
      Emitter<CategoryCreatetState> emit) async {
    if (_image == null) {
      emit(
          CategoryCreateErrorState('Please select an image before uploading.'));
    } else {
      emit(UploadingToDataBaseState(_image!));

      try {
        CreateCategoryUsecase usecase =
            CreateCategoryUsecase(Services.categoryRepo());
            
        CategoryEntity data = CategoryEntity(
            name: event.category, image: '', id: '', file: _image);
        await usecase.call(data);
        emit(UploadingCompletedState('Uploaded Successfully'));
      } catch (e) {
        emit(CategoryCreateErrorState(e.toString()));
      }
    }
  }
}
