// ignore_for_file: must_be_immutable

part of 'category_managemnt_bloc.dart';

@immutable
sealed class CategoryManagemntState {}

final class CategoryManagemntInitialState extends CategoryManagemntState {}

final class CategoryManagemntCompletedState extends CategoryManagemntState {
  List<CategoryEntity> data = [];
  CategoryManagemntCompletedState(this.data);
}

final class CategoryManagemntLoadingState extends CategoryManagemntState {}

final class CategoryManagemntErrorState extends CategoryManagemntState {
  String message;
  CategoryManagemntErrorState(this.message);
}
