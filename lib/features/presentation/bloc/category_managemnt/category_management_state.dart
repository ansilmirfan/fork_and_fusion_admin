// ignore_for_file: must_be_immutable

part of 'category_management_bloc.dart';

@immutable
sealed class CategoryManagementState {}

final class CategoryManagemntInitialState extends CategoryManagementState {}

final class CategoryManagemntCompletedState extends CategoryManagementState {
  List<CategoryEntity> data = [];
  CategoryManagemntCompletedState(this.data);
}

final class CategoryManagemntLoadingState extends CategoryManagementState {}

final class CategoryManagemntDeletionCompleted
    extends CategoryManagementState {}

final class CategoryManagementErrorState extends CategoryManagementState {
  String message;
  CategoryManagementErrorState(this.message);
}

final class CMImagePickerCompletedState extends CategoryManagementState {
  File image;
  CMImagePickerCompletedState(this.image);
}

final class CMUploadingToDataBaseState extends CategoryManagementState {
  File? image;
  String? url;
  CMUploadingToDataBaseState([this.image, this.url]);
}

final class CMUploadingCompletedState extends CategoryManagementState {
  String message;
  CMUploadingCompletedState(this.message);
}

final class CategoryManagementSearchingState extends CategoryManagementState {}

final class CategoryManagementSearchCompletedState
    extends CategoryManagementState {
  List<CategoryEntity> data = [];
  CategoryManagementSearchCompletedState(this.data);
}
