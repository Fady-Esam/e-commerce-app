import 'package:firebase_auth/firebase_auth.dart';

class AuthState {}

class AuthInitialState extends AuthState {}

//? Log In

class LogInSuccessState extends AuthState {}

class LogInFailureState extends AuthState {
  final String errMessage;

  LogInFailureState({required this.errMessage});
}

class LogInLoadingState extends AuthState {}

//? Sign Up 

class SignUpSuccessState extends AuthState {}

class SignUpFailureState extends AuthState {
  final String errMessage;

  SignUpFailureState({required this.errMessage});
}

class SignUpLoadingState extends AuthState {}

//? Sign In Wiht Google

class SignInWithGoogleSuccessState extends AuthState {
  final UserCredential authResults;

  SignInWithGoogleSuccessState({required this.authResults});
}

class SignInWithGoogleFailureState extends AuthState {
  final String errMessage;
  final bool isCredentialNull;
  SignInWithGoogleFailureState(
      {required this.errMessage, this.isCredentialNull = false});
}

class SignInWithGoogleLoadingState extends AuthState {}

//? Log Out

class LogOutSuccessState extends AuthState {}

class LogOutFailureState extends AuthState {
  final String errMessage;

  LogOutFailureState({required this.errMessage});
}

class LogOutLoadingState extends AuthState {}
