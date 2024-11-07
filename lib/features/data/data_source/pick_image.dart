// ignore_for_file: use_build_context_synchronously, unnecessary_nullable_for_final_variable_declarations

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class PickImageDataSource {
  final ImagePicker _picker = ImagePicker();

  Future<List<CroppedFile?>> pickImages({
    required BuildContext context,
    bool isMultiple = false,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      if (isMultiple) {
        // --------------Pick multiple images-------------
        final List<XFile>? images = await _picker.pickMultiImage();
        List<CroppedFile?> croppedFiles = [];

        // ----------------If images are picked--------------
        if (images != null && images.isNotEmpty) {
          for (var image in images) {
            CroppedFile? croppedFile = await _cropImage(context, image.path);
            croppedFiles.add(croppedFile);
          }
        }
        return croppedFiles;
      } else {
        //--------------picking a single image-------------------
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          CroppedFile? croppedFile = await _cropImage(context, image.path);
          return [croppedFile];
        }
      }
    } catch (e) {
      throw 'Failed to pick and crop images. Please try again';
    }
    return [];
  }

//--------------------cropping-------------------------
  Future<CroppedFile?> _cropImage(
      BuildContext context, String imagePath) async {
    return await ImageCropper().cropImage(
      sourcePath: imagePath,
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
  }
}
