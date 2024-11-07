import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

abstract class ImageRepo {
  Future<CroppedFile?> pickImage(BuildContext context);
  Future<List<CroppedFile?>> pickMultipleImages(BuildContext context);
}
