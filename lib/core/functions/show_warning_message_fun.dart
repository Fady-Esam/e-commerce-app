import 'package:flutter/material.dart';

Future<void> showWarningMessageFun(
    {required BuildContext context, required String text}) async {
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
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
