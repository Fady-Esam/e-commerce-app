import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LogInLoadingState());
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: event.email, password: event.password);
          emit(LogInSuccessState());
        } on FirebaseAuthException catch (e) {
          emit(LogInFailureState(errMessage: e.code));
        } catch (e) {
          emit(LogInFailureState(errMessage: 'An error has been occurred'));
        }
      } else if (event is SignUpEvent) {
        emit(SignUpLoadingState());
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: event.email, password: event.password);
          emit(SignUpSuccessState());
        } on FirebaseAuthException catch (e) {
          emit(SignUpFailureState(errMessage: e.code));
        } catch (e) {
          emit(SignUpFailureState(errMessage: 'An error has been occurred'));
        }
      } else if (event is SignInWithGoogleEvent) {
        emit(SignInWithGoogleLoadingState());
        try {
          final googleSignIn = GoogleSignIn();
          final googleAccount = await googleSignIn.signIn();
          if (googleAccount != null) {
            final googleAuth = await googleAccount.authentication;
            if (googleAuth.accessToken != null && googleAuth.idToken != null) {
              final UserCredential authResults =
                  await FirebaseAuth.instance.signInWithCredential(
                GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                ),
              );
              emit(SignInWithGoogleSuccessState(authResults: authResults));
            }
          } else {
            emit(
              SignInWithGoogleFailureState(
                errMessage: 'An error has been occurred',
                isCredentialNull: true,
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          emit(SignInWithGoogleFailureState(errMessage: e.code));
        } catch (e) {
          emit(SignInWithGoogleFailureState(
              errMessage: 'An error has been occurred'));
        }
      } else if (event is LogOutEvent) {
        emit(LogOutLoadingState());
        try {
          await FirebaseAuth.instance.signOut();
          emit(LogOutSuccessState());
        } on FirebaseAuthException catch (e) {
          emit(LogOutFailureState(errMessage: e.code));
        } catch (e) {
          emit(LogOutFailureState(errMessage: 'An error has been occurred'));
        }
      }
    });
  }
}
