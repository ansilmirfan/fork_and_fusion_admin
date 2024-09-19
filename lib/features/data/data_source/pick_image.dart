// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class PickImageDataSource {
  final ImagePicker _picker = ImagePicker();
  Future<CroppedFile?> pickImage(BuildContext context) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop image',
              toolbarColor: const Color(0xFFFF6B01),
              toolbarWidgetColor: Colors.white,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );
        return croppedFile;
      } else {
        throw 'Something went wrong';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
