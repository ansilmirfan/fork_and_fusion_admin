
import 'package:fork_and_fusion_admin/features/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required super.userName,
      required super.email,
      required super.userId,
      super.image});
  factory UserModel.fromMap(Map<String,dynamic>map) {
    return UserModel(
        userName:map['name']??'',
        email: map['email']??'',
        userId: map['uid']??'',
        image: map['image url']??''
       );
  }
}
