import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_event.dart';
import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_state.dart';
import 'package:ewsrtes/Features/auth/presentation/views/widgets/welcome_section.dart';
import 'package:ewsrtes/core/cubits/user_data_cubit/user_data_cubit.dart';
import 'package:ewsrtes/core/functions/show_snack_bar_fun.dart';
import 'package:ewsrtes/core/functions/show_warning_message_fun.dart';
import 'package:ewsrtes/core/widgets/tabs_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/cubits/guest_cubit/guest_cubit.dart';
import 'functions/show_image_warning_dialog.dart';
import 'widgets/custom_text_form_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String email = '';
  String password = '';
  bool isVisible = false;
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final ImagePicker imagePicker = ImagePicker();
  File? pickedImage;
  bool isLoading = false;
  var userName = TextEditingController();
  late String imageUrl;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpLoadingState) {
          isLoading = true;
        } else if (state is SignUpFailureState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
            context: context,
            text: "${state.errMessage}, Please try again",
          );
          isLoading = false;
        } else if (state is SignUpSuccessState) {
          BlocProvider.of<UserDataCubit>(context).sendUserData(
            userId: FirebaseAuth.instance.currentUser!.uid,
            userImage: imageUrl,
            userName: userName.text,
            userEmail: email.toLowerCase(),
            createdAt: Timestamp.now(),
            userCart: [],
            userWish: [],
          );
          BlocProvider.of<GuestCubit>(context).setIsGuest(isGuest: false);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
              context: context, text: 'Signing Up done Successfully');
          isLoading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TabsNav(),
            ),
          );
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
                      const SizedBox(height: 40),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      const WelcomeSection(isFromSignUp: true),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2.5,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: pickedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        pickedImage!,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Positioned(
                              top: -20,
                              right: -20,
                              child: IconButton(
                                color: Colors.blue,
                                onPressed: () async {
                                  String? option = await showImageWarningDialog(
                                    context: context,
                                    pcikedImage: pickedImage,
                                  );
                                  if (option == 'Camera' ||
                                      option == 'Gallery') {
                                    final XFile? image =
                                        await imagePicker.pickImage(
                                      source: option == 'Camera'
                                          ? ImageSource.camera
                                          : ImageSource.gallery,
                                    );
                                    if (image == null) {
                                      return;
                                    } else {
                                      pickedImage = File(image.path);
                                      setState(() {});
                                    }
                                  } else if (option == 'Remove') {
                                    pickedImage = null;
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Color.fromARGB(255, 158, 158, 158),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: userName,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'UserName Field is required';
                          } else if (value.trim().length < 3 ||
                              value.trim().length > 20) {
                            return 'UserName charcters must be between 3 and 20';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'UserName',
                          prefixIcon: const Icon(
                            Icons.supervised_user_circle_sharp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
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
                      const SizedBox(height: 18),
                      TextFormField(
                        validator: (value) {
                          if (value != password) {
                            return 'Not matching password';
                          }
                          return null;
                        },
                        autovalidateMode: autovalidateMode,
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              isVisible = !isVisible;
                              setState(() {});
                            },
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.password,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (pickedImage == null) {
                                await showWarningMessageFun(
                                  context: context,
                                  text: 'Make sure that you picked an image',
                                );
                              } else {
                                Reference ref = FirebaseStorage.instance
                                    .ref()
                                    .child('usersImages')
                                    .child('${const Uuid().v4()}.jpg');
                                await ref.putFile(pickedImage!);
                                imageUrl = await ref.getDownloadURL();
                                setState(() {});
                                BlocProvider.of<AuthBloc>(context).add(
                                  SignUpEvent(
                                    email: email,
                                    password: password,
                                  ),
                                );
                              }
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
                                  MediaQuery.sizeOf(context).width * 0.32,
                              vertical: 12,
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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
