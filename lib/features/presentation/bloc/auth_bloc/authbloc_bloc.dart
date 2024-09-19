import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fork_and_fusion_admin/features/data/repository/auth_repository.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/auth_usecase/authenticate_admin_usecase.dart';
import 'package:meta/meta.dart';

part 'authbloc_event.dart';
part 'authbloc_state.dart';

class AuthBloc extends Bloc<AuthblocEvent, AuthblocState> {
  AuthBloc() : super(AuthblocInitial()) {
    on<AuthValidateEvent>(authValidateEvent);
  }

  FutureOr<void> authValidateEvent(
      AuthValidateEvent event, Emitter<AuthblocState> emit) async {
    emit(AuthLoadingState());
    try {
      AuthRepository repo = AuthRepository();
      AuthenticateAdminUsecase usecase = AuthenticateAdminUsecase(repo);
      final success = await usecase.call(event.name, event.password);
      if (success) {
        emit(AuthCompletedState());
      } else {
        emit(AuthErrorState('Invalid username or password. Please try again.'));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
