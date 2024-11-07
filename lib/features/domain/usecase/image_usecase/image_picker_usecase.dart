import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/image_repo/image_repo.dart';

class ImagePickerUsecase {
  ImageRepo repo;
  ImagePickerUsecase(this.repo);
  Future<File?> call(BuildContext context) async {
    final image = await repo.pickImage(context);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}
