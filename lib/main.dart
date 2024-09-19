import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/auth_bloc/authbloc_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_managemnt_bloc.dart';

import 'package:fork_and_fusion_admin/features/presentation/bloc/drawer_page/drawer_page_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/routs/routes.dart';
import 'package:fork_and_fusion_admin/features/presentation/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => DrawerPageBloc(),
        ),
        BlocProvider(
          create: (context) => CategoryManagemntBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.primaryTheme,
        onGenerateRoute: Routes.routes,
        initialRoute: '/',
      ),
    );
  }
}
