import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/cached_image.dart';

Material imageWidget(BuildContext context,
    {bool image = true,
    String url = '',
    required ProductManagementBloc bloc,
    File? file}) {
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
        child: image
            ? file != null
                ? Image.file(file)
                : CachedImage(url: url)
            : const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo,
                    size: 60,
                  ),
                  Text('Click here to add image')
                ],
              ),
      ),
    ),
  );
}
