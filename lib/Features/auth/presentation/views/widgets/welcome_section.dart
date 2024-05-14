import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_shimmer.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key, required this.isFromSignUp});

  final bool isFromSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.center,
          child: CustomShimmer(
            text: 'ShopSmart',
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          
              "Let's ${isFromSignUp ? 'Sign Up' : 'Log In'}, so you can start in exploring",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
