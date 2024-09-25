import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/cached_image.dart';

class CustomeCircleAvathar extends StatelessWidget {
  String url;
  double radius;
  CustomeCircleAvathar({super.key, required this.url, this.radius = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedImage(url: url),
      ),
    );
  }
}
