import 'dart:typed_data';

import 'package:fork_and_fusion_admin/features/domain/repository/pdf_generator/pdf_repo.dart';

class QrImageGenerateUsecase {
  PdfRepo repo;
  QrImageGenerateUsecase(this.repo);
  Future<List<Uint8List>> call(int tableCount) async {
    return await repo.generateQrImages(tableCount);
  }
}
