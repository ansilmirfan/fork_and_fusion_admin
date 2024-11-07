part of 'pdf_generator_bloc.dart';

@immutable
sealed class PdfGeneratorState {}

final class PdfGeneratorInitialState extends PdfGeneratorState {}

final class PdfGeneratorLoadingState extends PdfGeneratorState {}

final class PdfGeneratorCompletedState extends PdfGeneratorState {}

final class PdfGeneratorErrorState extends PdfGeneratorState {
  String message;
  PdfGeneratorErrorState(this.message);
}
