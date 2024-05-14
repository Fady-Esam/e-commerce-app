import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/presentation/manager/blocs/auth_bloc/auth_bloc.dart';
import '../../../../auth/presentation/manager/blocs/auth_bloc/auth_event.dart';
import '../../../../auth/presentation/views/sign_in_view.dart';

class LogOutOrSignInCustomButton extends StatelessWidget {
  const LogOutOrSignInCustomButton({
    super.key,
    required this.currentUser,
  });

  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.blue,
      ),
      child: TextButton.icon(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'admin_assets/assets/images/warning.png',
                    height: 120,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    currentUser == null
                        ? 'Are you sure to log in?'
                        : 'Are you sure to log out?',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          currentUser != null
                              ? BlocProvider.of<AuthBloc>(context)
                                  .add(LogOutEvent())
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInView(),
                                  ),
                                );
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        icon: Icon(
          currentUser == null ? Icons.login : Icons.logout,
          color: Colors.white,
        ),
        label: Text(
          currentUser == null ? 'Log In' : 'Log Out',
          style: const TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
