import 'package:flutter/material.dart';



Future<void> showOptionDialog(
    {required BuildContext context,
    required String warningText,
    required void Function() onYesPress}) async {
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
            warningText,
            textAlign: TextAlign.center,
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
                onPressed: onYesPress,
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
}
