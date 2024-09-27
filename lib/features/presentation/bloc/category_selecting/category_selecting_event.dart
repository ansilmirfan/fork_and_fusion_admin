part of 'category_selecting_bloc.dart';

@immutable
sealed class CategorySelectingEvent {}

class CategorySelectingInitialEvent extends CategorySelectingEvent {}

class CategorySelectingChangedEvent extends CategorySelectingEvent {
  int index;
  CategorySelectingChangedEvent(this.index);
}

class CategoryUpdateSelectedEvent extends CategorySelectingEvent {
  List<CategoryEntity> data = [];
  CategoryUpdateSelectedEvent(this.data);
}

class CategoryDisSelectEvent extends CategorySelectingEvent {
  String id;
  CategoryDisSelectEvent(this.id);
}
