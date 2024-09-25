part of 'product_management_bloc.dart';

@immutable
sealed class ProductManagementState {}

final class ProductManagementInitialState extends ProductManagementState {}

final class ProductManagementCompletedState extends ProductManagementState {
  List<ProductEntity> data;
  ProductManagementCompletedState(this.data);
}

final class ProductManagementLoadingState extends ProductManagementState {}

final class ProductManagementErrorState extends ProductManagementState {
  String message;
  ProductManagementErrorState(this.message);
}

final class ProductManagementDataUpdatedState extends ProductManagementState {
  File image;
  Map<String, num> variants;
  ProductManagementDataUpdatedState(this.image, {this.variants=const {}});
}

final class ProductManagementUploadingToDataBaseState
    extends ProductManagementState {
  File? image;
  String? url;
  ProductManagementUploadingToDataBaseState([this.image, this.url]);
}

final class ProductManagementUploadingCompletedState
    extends ProductManagementState {
  String message;
  ProductManagementUploadingCompletedState(this.message);
}

final class ProductManagementSearchingState extends ProductManagementState {}

final class ProductManagementSearchCompletedState
    extends ProductManagementState {
  List<ProductEntity> data = [];
  ProductManagementSearchCompletedState(this.data);
}
