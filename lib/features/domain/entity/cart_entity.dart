

import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';

class CartEntity {
  String id;
  ProductEntity product;
  int quantity;
  bool parcel;
  bool isSelected;
  String cookingRequest;
  bool rated;
  String status;
  String selectedType;
  CartEntity(
      {required this.id,
    
      required this.product,
      required this.quantity,
      this.cookingRequest = '',
      this.parcel = false,
      this.status = '',
      this.isSelected = false,
      this.rated=false,
      this.selectedType = ''});
}
