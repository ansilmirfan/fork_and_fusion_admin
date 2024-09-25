// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/cached_image.dart';

class CategoryView extends StatelessWidget {
  CategoryEntity data;
  CategoryView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Padding(
          padding: Constants.padding10,
          child: Hero(
            tag: data.name,
            child: Material(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: Constants.radius,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitleAndPopButton(context),
                    _buildImage(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildTitleAndPopButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Utils.capitalizeEachWord(data.name)),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          )
        ],
      ),
    );
  }

  Padding _buildImage() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: Constants.radius,
        child: CachedImage(
          url: data.image,
        ),
      ),
    );
  }
}
