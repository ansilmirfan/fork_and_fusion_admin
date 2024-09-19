// ignore_for_file: must_be_immutable

part of 'category_management_bloc.dart';

@immutable
sealed class CategoryCreatetState {}

final class CategoryCreateInitialState extends CategoryCreatetState {}

final class ImagePickerCompletedState extends CategoryCreatetState {
  File image;
  ImagePickerCompletedState(this.image);
}

final class CategoryCreateErrorState extends CategoryCreatetState {
  String message;
  CategoryCreateErrorState(this.message);
}

final class UploadingToDataBaseState extends CategoryCreatetState {
  File image;
  UploadingToDataBaseState(this.image);
}

final class UploadingCompletedState extends CategoryCreatetState {
  String message;
  UploadingCompletedState(this.message);
}
