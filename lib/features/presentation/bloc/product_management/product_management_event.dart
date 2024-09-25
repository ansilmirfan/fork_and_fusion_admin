part of 'product_management_bloc.dart';

@immutable
sealed class ProductManagementEvent {}

final class ProductManagementImagePickerEvent extends ProductManagementEvent {
  BuildContext context;
  ProductManagementImagePickerEvent(this.context);
}

final class ProductManagementGetAllEvent extends ProductManagementEvent {}

final class ProductManagementEditEvent extends ProductManagementEvent {
  ProductEntity newData;
  String id;
  ProductManagementEditEvent(this.id, this.newData);
}

final class ProductManagementDeleteEvent extends ProductManagementEvent {
  String id;
  String image;
  ProductManagementDeleteEvent(this.id, this.image);
}

final class ProductManagementCreateEvent extends ProductManagementEvent {
  ProductEntity data;
  ProductManagementCreateEvent(this.data);
}

final class ProductManagementSearchingEvent extends ProductManagementEvent {
  String querry;
  ProductManagementSearchingEvent(this.querry);
}
