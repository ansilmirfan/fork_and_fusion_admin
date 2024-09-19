import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'drawer_page_event.dart';
part 'drawer_page_state.dart';

class DrawerPageBloc extends Bloc<DrawerPageEvent, DrawerPageState> {
  DrawerPageBloc() : super(DrawerPageInitialState(0)) {
    on<DrawerPageChangedEvent>(drawerPageChangedEvent);
  }

  FutureOr<void> drawerPageChangedEvent(
      DrawerPageChangedEvent event, Emitter<DrawerPageState> emit) {
    emit(DrawerPageChangedState(event.currentPage));
  }
}
