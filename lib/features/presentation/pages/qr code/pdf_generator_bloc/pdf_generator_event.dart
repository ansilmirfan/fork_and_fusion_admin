part of 'pdf_generator_bloc.dart';

@immutable
sealed class PdfGeneratorEvent {}

final class PdfGeneratorIntialEvent extends PdfGeneratorEvent {
  int tableCount;
  PdfGeneratorIntialEvent(this.tableCount);
}
