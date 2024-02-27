part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  String verificationCode;
  AuthSuccess({required this.verificationCode});
}

final class AuthFailure extends AuthState {
  String error;
  AuthFailure({required this.error});
}
