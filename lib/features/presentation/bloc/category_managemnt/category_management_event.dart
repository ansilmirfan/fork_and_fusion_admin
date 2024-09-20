// ignore_for_file: must_be_immutable

part of 'category_management_bloc.dart';

@immutable
sealed class CategoryManagemntEvent {}

final class CategoryManagemntGetAllEvent extends CategoryManagemntEvent {}

final class CategoryManagementDeleteEvent extends CategoryManagemntEvent {
  String id;
  String image;
  CategoryManagementDeleteEvent(this.id, this.image);
}

final class CategoryManagementEditEvent extends CategoryManagemntEvent {
  CategoryEntity newData;
  String id;
  CategoryManagementEditEvent(this.id, this.newData);
}

final class CategoryManagentCreateEvent extends CategoryManagemntEvent {
  String category;
  CategoryManagentCreateEvent(this.category);
}

final class CategoryManagementImagePickerEvent extends CategoryManagemntEvent {
  BuildContext context;
  CategoryManagementImagePickerEvent(this.context);
}

final class CategoryManagementSearchingEvent extends CategoryManagemntEvent {
  String querry;
  CategoryManagementSearchingEvent(this.querry);
}
