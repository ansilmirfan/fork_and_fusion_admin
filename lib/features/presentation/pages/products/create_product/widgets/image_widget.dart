import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/cached_image.dart';

Material imageWidget(BuildContext context,
    {bool image = true,
    List<String> url = const [],
    required ProductManagementBloc bloc,
    List<File?>? file}) {
  return Material(
    elevation: 10,
    borderRadius: Constants.radius,
    child: InkWell(
      onTap: () {
        bloc.add(ProductManagementImagePickerEvent(context));
      },
      child: Container(
        alignment: AlignmentDirectional.center,
        height: Constants.dHeight * .25,
        padding: Constants.padding10,
        //-----------either image or icon----------------------------
        child: image
            ? file != null
                ? _image(file: file)
                : _image(fromFile: false, url: url)
            : const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo, size: 60),
                  Text('Click here to add image')
                ],
              ),
      ),
    ),
  );
}

SingleChildScrollView _image(
    {bool fromFile = true,
    List<File?> file = const [],
    List<String> url = const []}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Wrap(
        spacing: 10,
        children: List.generate(
          fromFile ? file.length : url.length,
          (index) => SizedBox(
              width: Constants.dWidth * 0.9,
              height:Constants.dHeight * .25 ,
              child: fromFile
                  ? Image.file(file[index]!,fit: BoxFit.cover,)
                  : CachedImage(
                      url: url[index],
                    )),
        )),
  );
}
