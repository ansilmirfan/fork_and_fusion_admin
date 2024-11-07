import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

class PdfGeneratorDataSource {
  Future<List<Uint8List>> generateQrCodeImages(int tableCount) async {
    List<Uint8List> qrImages = [];

    for (int i = 0; i < tableCount; i++) {
      final qrImage =
          await generateQrCodeImage('Fork and Fusion_Table_A${i + 1}');
      qrImages.add(qrImage);
    }

    return qrImages;
  }

  Future<Uint8List> generateQrCodeImage(String data) async {
    final qrPainter =
        QrPainter(data: data, version: QrVersions.auto, gapless: false);
    final picture = await qrPainter.toImageData(200);
    return picture!.buffer.asUint8List();
  }

  Future<void> generatePdf(List<Uint8List> qrImages) async {
    final pdf = pw.Document();

    final ByteData logoData =
        await rootBundle.load('asset/images/fork fution.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    for (int index = 0; index < qrImages.length; index++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(
                    logoImage,
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Table ${index + 1}',
                      style: const pw.TextStyle(fontSize: 24)),
                  pw.SizedBox(height: 20),
                  pw.Image(
                    pw.MemoryImage(qrImages[index]),
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
