import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fork_and_fusion_admin/core/services/services.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/category/get_category_usecase.dart';
import 'package:meta/meta.dart';

part 'category_managemnt_event.dart';
part 'category_managemnt_state.dart';

class CategoryManagemntBloc
    extends Bloc<CategoryManagemntEvent, CategoryManagemntState> {
  CategoryManagemntBloc() : super(CategoryManagemntInitialState()) {
    on<CategoryManagemntGetAllEvent>(categoryManagemntGetAllEvent);
  }

  FutureOr<void> categoryManagemntGetAllEvent(
      CategoryManagemntGetAllEvent event,
      Emitter<CategoryManagemntState> emit) async {
    emit(CategoryManagemntLoadingState());
    try {
      GetCategoryUsecase usecase = GetCategoryUsecase(Services.categoryRepo());
      final data = await usecase.call();
      emit(CategoryManagemntCompletedState(data));
    } catch (e) {
      emit(CategoryManagemntErrorState(e.toString()));
    }
  }
}
