import 'package:flutter/material.dart';

import '../sign_up_view.dart';

class CheckSigningUpCusomRow extends StatelessWidget {
  const CheckSigningUpCusomRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account ? ",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpView(),
              ),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
