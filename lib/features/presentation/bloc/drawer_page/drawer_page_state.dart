// ignore_for_file: must_be_immutable

part of 'drawer_page_bloc.dart';

@immutable
sealed class DrawerPageState {}

final class DrawerPageInitialState extends DrawerPageState {
  int currentPage;
  DrawerPageInitialState(this.currentPage);
}

final class DrawerPageChangedState extends DrawerPageState {
  int currentPage;
  DrawerPageChangedState(this.currentPage);
}
