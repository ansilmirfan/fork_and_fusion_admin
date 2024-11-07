import 'dart:typed_data';

import 'package:fork_and_fusion_admin/features/domain/repository/pdf_generator/pdf_repo.dart';

class PdfGeneratorUsecase {
  PdfRepo repo;
  PdfGeneratorUsecase(this.repo);
  Future<void> call(List<Uint8List> images) async {
    await repo.generatePdf(images);
  }
}
