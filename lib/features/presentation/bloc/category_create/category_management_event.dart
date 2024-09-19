// ignore_for_file: must_be_immutable

part of 'category_management_bloc.dart';

@immutable
sealed class CategoryCreateEvent {}

final class ImagePickerEvent extends CategoryCreateEvent {
  BuildContext context;
  ImagePickerEvent(this.context);
}

final class UploadingToDatabaseEvent extends CategoryCreateEvent {
  String category;
  UploadingToDatabaseEvent(this.category);
}
