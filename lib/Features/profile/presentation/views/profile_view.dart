import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_state.dart';
import 'package:ewsrtes/Features/auth/presentation/views/sign_in_view.dart';
import 'package:ewsrtes/core/cubits/guest_cubit/guest_cubit.dart';
import 'package:ewsrtes/core/cubits/user_data_cubit/user_data_cubit.dart';
import 'package:ewsrtes/core/functions/show_snack_bar_fun.dart';
import 'package:ewsrtes/core/models/user_model.dart';
import 'package:ewsrtes/core/widgets/image_and_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'widgets/log_out_or_sign_in_custom_button.dart';
import 'widgets/profile_list_tile_body.dart';
import 'widgets/user_data_cusotm_row.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive {
    return true;
  }

  User? currentUser = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool isLoading = false;
  Future<void> fetchUserData() async {
    userModel = await BlocProvider.of<UserDataCubit>(context)
        .fetchUserData(id: FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogOutLoadingState) {
          isLoading = true;
        } else if (state is LogOutFailureState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
              context: context, text: "${state.errMessage}, please try again");
          isLoading = false;
        } else if (state is LogOutSuccessState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
            context: context,
            text: 'Logining Out done successfully',
          );
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInView(),
            ),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const ImageAndShimmer(
                text: 'Profile Info',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    !BlocProvider.of<GuestCubit>(context).isUserGuest
                        ? UserDataCustomRow(userModel: userModel)
                        : const Text(
                            'Login to save your details and access your info',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                    const SizedBox(height: 18),
                    const Text(
                      'General',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const ProfileListTileBody(),
                    const SizedBox(height: 32),
                    Center(
                      child:
                          LogOutOrSignInCustomButton(currentUser: currentUser),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
