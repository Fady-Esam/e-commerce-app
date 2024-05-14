
class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email, password;

  LoginEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String email, password;

  SignUpEvent({required this.email, required this.password});
}

class SignInWithGoogleEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}
