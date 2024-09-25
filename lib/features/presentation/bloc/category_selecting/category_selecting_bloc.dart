import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fork_and_fusion_admin/core/services/services.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/category/get_category_usecase.dart';
import 'package:meta/meta.dart';

part 'category_selecting_event.dart';
part 'category_selecting_state.dart';

class CategorySelectingBloc
    extends Bloc<CategorySelectingEvent, CategorySelectingState> {
  CategorySelectingBloc() : super(CategorySelectingInitialState()) {
    on<CategorySelectingInitialEvent>(categorySelectingInitialEvent);
    on<CategorySelectingChangedEvent>(categorySelectingChangedEvent);
    on<CategoryDisSelectEvent>(categoryDisSelectEvent);
  }

  FutureOr<void> categorySelectingInitialEvent(
      CategorySelectingInitialEvent event,
      Emitter<CategorySelectingState> emit) async {
    emit(CategorySelectingLoadingState());
    try {
      GetCategoryUsecase usecase = GetCategoryUsecase(Services.categoryRepo());
      final data = await usecase.call();
      emit(CategorySelectingCompletedState(data));
    } catch (e) {
      emit(CategorySelectingErrorState('Something went wrong'));
    }
  }

  FutureOr<void> categorySelectingChangedEvent(
      CategorySelectingChangedEvent event,
      Emitter<CategorySelectingState> emit) {
    final data = (state as CategorySelectingCompletedState).category;
    data[event.index].selected = !data[event.index].selected;
    emit(CategorySelectingCompletedState(data));
  }

  FutureOr<void> categoryDisSelectEvent(
      CategoryDisSelectEvent event, Emitter<CategorySelectingState> emit) {
    final data = (state as CategorySelectingCompletedState).category;
    for (var i in data) {
      if (i.id == event.id) {
        i.selected = false;
      }
    }
    emit(CategorySelectingCompletedState(data));
  }
}
