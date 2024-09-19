// ignore_for_file: must_be_immutable

part of 'category_managemnt_bloc.dart';

@immutable
sealed class CategoryManagemntEvent {}

final class CategoryManagemntGetAllEvent extends CategoryManagemntEvent{}
