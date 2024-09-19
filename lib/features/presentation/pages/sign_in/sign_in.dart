// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/auth_bloc/authbloc_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custome_textform_field.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/logo.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/snackbar.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/textbutton.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final gap = const SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: Constants.signIn,
              child: Center(
                child: Column(
                  children: [
                    Logo(width: Constants.dWidth * .7),
                    _titleText(context),
                    gap,
                    _subtitleText(context),
                    gap,
                    _descriptionText(),
                    _buildTextFromFields(),
                    _buildSignInbutton(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BlocConsumer _buildSignInbutton(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthblocState>(
      listener: (context, state) {
        if (state is AuthCompletedState) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
        if (state is AuthErrorState) {
          showCustomSnackbar(
              context: context, message: state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        if (state is AuthLoadingState) {
          return CustomTextButton(progress: true);
        }
        return CustomTextButton(
          text: 'Signin',
          onPressed: () async {
            if (Constants.signIn.currentState!.validate()) {
              context.read<AuthBloc>().add(AuthValidateEvent(
                  usernameController.text.trim(),
                  passwordController.text.trim()));
            }
          },
        );
      },
    );
  }

  Column _buildTextFromFields() {
    return Column(
      children: [
        gap,
        CustomeTextField(
          hintText: "username",
          validator: Validation.validateName,
          controller: usernameController,
        ),
        gap,
        CustomeTextField(
          hintText: "password",
          obsuceText: true,
          suffixIcon: true,
          validator: Validation.passwordValidation,
          controller: passwordController,
        ),
        gap,
        gap,
      ],
    );
  }

  SizedBox _descriptionText() {
    return SizedBox(
      width: Constants.dWidth * .9,
      child: const Text(
        'Use your admin username and password to access your dashboard and manage operations securely',
        textAlign: TextAlign.center,
      ),
    );
  }

  Text _subtitleText(BuildContext context) {
    return Text(
      'Please signin to continue',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Text _titleText(BuildContext context) {
    return Text(
      'Welcome Admin',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
