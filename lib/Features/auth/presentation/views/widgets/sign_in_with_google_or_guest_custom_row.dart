import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../core/widgets/tabs_nav.dart';
import '../../manager/blocs/auth_bloc/auth_bloc.dart';
import '../../manager/blocs/auth_bloc/auth_event.dart';

class SignInWithGoogleOrGuestCustomRow extends StatefulWidget {
  const SignInWithGoogleOrGuestCustomRow({
    super.key,
  });

  @override
  State<SignInWithGoogleOrGuestCustomRow> createState() =>
      _SignInWithGoogleOrGuestCustomRowState();
}

class _SignInWithGoogleOrGuestCustomRowState
    extends State<SignInWithGoogleOrGuestCustomRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(SignInWithGoogleEvent());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(
            Ionicons.logo_google,
            color: Colors.red.withOpacity(0.7),
          ),
          label: const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Sign In With Google',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TabsNav()),
                (route) => false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Guest?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
