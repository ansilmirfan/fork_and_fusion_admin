part of 'product_management_bloc.dart';

@immutable
sealed class ProductManagementState {}

final class ProductManagementInitialState extends ProductManagementState {}

final class ProductManagementCompletedState extends ProductManagementState {
  List<ProductEntity> data;

  ProductManagementCompletedState(this.data);
}

class NodataState extends ProductManagementState {}

final class ProductManagementLoadingState extends ProductManagementState {
  List<String>? url;
  List<File?>? file;
  ProductManagementLoadingState(this.file, this.url);
}

final class ProductManagementEditCompletedState
    extends ProductManagementState {}

final class ProductManagementDeleteCompletedState
    extends ProductManagementState {}

final class ProductManagementErrorState extends ProductManagementState {
  String message;
  ProductManagementErrorState(this.message);
}

final class ProductManagementDataUpdatedState extends ProductManagementState {
  List<File> images;
  Map<String, num> variants;
  ProductManagementDataUpdatedState(this.images, {this.variants = const {}});
}

final class ProductManagementUploadingToDataBaseState
    extends ProductManagementState {
  List<String?>? url;
  List<File?>? file;
  ProductManagementUploadingToDataBaseState([this.file, this.url]);
}

final class ProductManagementUploadingCompletedState
    extends ProductManagementState {
  String message;
  ProductManagementUploadingCompletedState(this.message);
}

final class ProductManagementSearchingState extends ProductManagementState {}

class ProductManagementSearchCompletedState extends ProductManagementState {
  List<ProductEntity> data;
  ProductManagementSearchCompletedState(this.data);
}

class ProductManagementNoDataInFilter extends ProductManagementState {
  String message =
      "Oops! We couldn't find any matching results. Maybe try different filters?";
}
