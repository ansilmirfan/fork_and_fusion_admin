

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/data/data_source/pick_image.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/image_repo/image_repo.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageRepository implements ImageRepo {
  PickImageDataSource dataSource = PickImageDataSource();
  @override
  Future<CroppedFile?> pickImage(BuildContext context) {
    return dataSource.pickImage(context);
  }
}
