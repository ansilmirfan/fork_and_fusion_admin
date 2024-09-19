// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/data/repository/auth_repository.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/auth_usecase/create_admin_usecase.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Constants.dHeight = MediaQuery.of(context).size.height;
    Constants.dWidth = MediaQuery.of(context).size.width;
    AuthRepository repo = AuthRepository();
    CreateAdminUsecase usecase = CreateAdminUsecase(repo);
    usecase.call();
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacementNamed('/signin'),
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Logo(),
            const Text('Version 1.0.0.0'),
          ],
        ),
      ),
    );
  }
}
