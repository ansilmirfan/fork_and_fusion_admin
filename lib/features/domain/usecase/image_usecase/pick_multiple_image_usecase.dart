import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/image_repo/image_repo.dart';

class PickMultipleImageUsecase {
  ImageRepo repo;
  PickMultipleImageUsecase(this.repo);
  Future<List<File>>? call(BuildContext context) async {
    var result = await repo.pickMultipleImages(context);
    return result.map((e) => File(e!.path)).toList();
  }
}
