// ignore_for_file: must_be_immutable

part of 'drawer_page_bloc.dart';

@immutable
sealed class DrawerPageEvent {}

class DrawerPageChangedEvent extends DrawerPageEvent {
  int currentPage;
  DrawerPageChangedEvent(this.currentPage);
}
