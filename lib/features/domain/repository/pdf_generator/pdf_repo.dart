import 'dart:typed_data';

abstract class PdfRepo {
  Future<List<Uint8List>> generateQrImages(int tableCount);
  Future<void> generatePdf(List<Uint8List> images);
}
