import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/qr%20code/pdf_generator_bloc/pdf_generator_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';

import 'package:fork_and_fusion_admin/core/utils/validator/validation.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_textform_field.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/textbutton.dart';

class QrCodeGenerator extends StatelessWidget {
  QrCodeGenerator({super.key});

  final TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfGeneratorBloc(),
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(title: const Text('QR Code')),
        body: Padding(
          padding: Constants.padding15,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _textField(),
                const SizedBox(height: 10),
                _generateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocConsumer _generateButton() {
    return BlocConsumer<PdfGeneratorBloc, PdfGeneratorState>(
      listener: (context, state) {
        if (state is PdfGeneratorCompletedState) {
          controller.clear();
          formKey.currentState!.reset();
        }
      },
      builder: (context, state) {
        if (state is PdfGeneratorLoadingState) {
          return CustomTextButton(progress: true);
        }

        return CustomTextButton(
          text: 'Generate PDF',
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<PdfGeneratorBloc>().add(
                  PdfGeneratorIntialEvent(int.parse(controller.text.trim())));
            }
          },
        );
      },
    );
  }

  CustomTextField _textField() {
    return CustomTextField(
      width: 1,
      maxLength: 2,
      hintText: "Table Count",
      keyboardType: TextInputType.number,
      validator: (query) {
        return Validation.validateNumber(query, name: 'Table Count');
      },
      prefixIcon: const Icon(Icons.table_bar),
      controller: controller,
    );
  }
}
