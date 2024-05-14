import 'package:flutter/material.dart';

class EmptyBag extends StatelessWidget {
  const EmptyBag({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  final String image, title, subtitle, content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Image.asset(
            image,
            height: MediaQuery.sizeOf(context).height * 0.5,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
