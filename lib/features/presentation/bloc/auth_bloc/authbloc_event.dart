// ignore_for_file: must_be_immutable

part of 'authbloc_bloc.dart';

@immutable
sealed class AuthblocEvent {}

final class AuthValidateEvent extends AuthblocEvent {
  String name;
  String password;
  AuthValidateEvent(this.name, this.password);
}
