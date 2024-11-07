import 'dart:typed_data';

import 'package:fork_and_fusion_admin/features/data/data_source/pdf_generator.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/pdf_generator/pdf_repo.dart';

class PdfRepository extends PdfRepo {
  PdfGeneratorDataSource dataSource = PdfGeneratorDataSource();
  @override
  Future<void> generatePdf(List<Uint8List> images) async {
    await dataSource.generatePdf(images);
  }

  @override
  Future<List<Uint8List>> generateQrImages(int tableCount) async {
    return await dataSource.generateQrCodeImages(tableCount);
  }
}
