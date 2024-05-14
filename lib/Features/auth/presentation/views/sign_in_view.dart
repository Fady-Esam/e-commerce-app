import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_event.dart';
import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_state.dart';
import 'package:ewsrtes/Features/auth/presentation/views/widgets/custom_text_form_field.dart';
import 'package:ewsrtes/core/functions/show_snack_bar_fun.dart';
import 'package:ewsrtes/core/functions/show_warning_message_fun.dart';
import 'package:ewsrtes/core/widgets/tabs_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/cubits/guest_cubit/guest_cubit.dart';
import '../../../../core/cubits/user_data_cubit/user_data_cubit.dart';
import 'widgets/check_signing_up_custom_row.dart';
import 'widgets/forgot_password_cutom_button.dart';
import 'widgets/welcome_section.dart';
import 'widgets/sign_in_with_google_or_guest_custom_row.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String password = '';
  String email = '';
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogInLoadingState) {
          isLoading = true;
        } else if (state is LogInFailureState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
              context: context, text: '${state.errMessage}, Please try again');
          isLoading = false;
        } else if (state is LogInSuccessState) {
          BlocProvider.of<GuestCubit>(context).setIsGuest(isGuest: false);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
              context: context, text: 'Signing in Completed successfully');
          isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const TabsNav()));
        } else if (state is SignInWithGoogleLoadingState) {
          isLoading = true;
        } else if (state is SignInWithGoogleFailureState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          state.isCredentialNull
              ? null
              : showSnackBarFun(
                  context: context,
                  text: '${state.errMessage}, Please try again');
          isLoading = false;
        } else if (state is SignInWithGoogleSuccessState) {
          if (state.authResults.additionalUserInfo!.isNewUser) {
            BlocProvider.of<UserDataCubit>(context).sendUserData(
              userId: state.authResults.user!.uid,
              userImage: state.authResults.user!.photoURL!,
              userName: state.authResults.user!.displayName!,
              userEmail: state.authResults.user!.email!.toLowerCase(),
              createdAt: Timestamp.now(),
              userCart: [],
              userWish: [],
            );
          }
          BlocProvider.of<GuestCubit>(context).setIsGuest(isGuest: false);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showWarningMessageFun(
            context: context,
            text: 'Signing in With Google done successfully',
          );
          isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const TabsNav()));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Form(
                key: formKey,
                autovalidateMode: autovalidateMode,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      const WelcomeSection(isFromSignUp: false),
                      const SizedBox(height: 24),
                      CustomTextFormField(
                        hint: 'Email',
                        prefixIcon: Icons.email,
                        onChanged: (value) {
                          email = value;
                        },
                        autovalidateMode: autovalidateMode,
                      ),
                      const SizedBox(height: 18),
                      CustomTextFormField(
                        hint: 'Password',
                        prefixIcon: Icons.password,
                        onChanged: (value) {
                          password = value;
                        },
                        autovalidateMode: autovalidateMode,
                      ),
                      const SizedBox(height: 22),
                      const ForgotPasswordCustomButton(),
                      const SizedBox(
                        height: 26,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                  LoginEvent(email: email, password: password));
                            } else {
                              autovalidateMode = AutovalidateMode.always;
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.33,
                              vertical: 12,
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'OR CONNECT USING',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const SignInWithGoogleOrGuestCustomRow(),
                      const SizedBox(height: 28),
                      const CheckSigningUpCusomRow(),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
