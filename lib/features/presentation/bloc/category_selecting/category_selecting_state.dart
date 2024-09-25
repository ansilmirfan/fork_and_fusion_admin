part of 'category_selecting_bloc.dart';

@immutable
sealed class CategorySelectingState {}

final class CategorySelectingInitialState extends CategorySelectingState {}

final class CategorySelectingLoadingState extends CategorySelectingState {}

final class CategorySelectingCompletedState extends CategorySelectingState {
  List<CategoryEntity> category;
  CategorySelectingCompletedState(this.category);
}

final class CategorySelectingErrorState extends CategorySelectingState {
  String message;
  CategorySelectingErrorState(this.message);
}
