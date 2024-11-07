import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fork_and_fusion_admin/features/data/repository/pdf_repository.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/pdf_generator/pdf_repo.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/pdf_usecase/pdf_generator_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/pdf_usecase/qr_image_generate_usecase.dart';
import 'package:meta/meta.dart';

part 'pdf_generator_event.dart';
part 'pdf_generator_state.dart';

class PdfGeneratorBloc extends Bloc<PdfGeneratorEvent, PdfGeneratorState> {
  PdfGeneratorBloc() : super(PdfGeneratorInitialState()) {
    on<PdfGeneratorIntialEvent>(pdfGeneratorIntialEvent);
  }

  FutureOr<void> pdfGeneratorIntialEvent(
      PdfGeneratorIntialEvent event, Emitter<PdfGeneratorState> emit) async {
    emit(PdfGeneratorLoadingState());
    PdfRepo repo = PdfRepository();
    try {
      QrImageGenerateUsecase usecase = QrImageGenerateUsecase(repo);
      var images = await usecase.call(event.tableCount);
      PdfGeneratorUsecase pdfUsecase = PdfGeneratorUsecase(repo);
      await pdfUsecase.call(images);
      emit(PdfGeneratorCompletedState());
    } catch (e) {
      emit(PdfGeneratorErrorState(e.toString()));
    }
  }
}
