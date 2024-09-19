// ignore_for_file: must_be_immutable

part of 'authbloc_bloc.dart';

@immutable
sealed class AuthblocState {}

final class AuthblocInitial extends AuthblocState {}

final class AuthLoadingState extends AuthblocState {}

final class AuthErrorState extends AuthblocState {
  String message;
  AuthErrorState(this.message);
}
final class AuthCompletedState extends AuthblocState{}
