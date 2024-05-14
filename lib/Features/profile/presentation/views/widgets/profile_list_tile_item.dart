import 'package:flutter/material.dart';


class ProfileListTileItem extends StatelessWidget {
  const ProfileListTileItem(
      {super.key,
      required this.image,
      required this.title,
      required this.onTap});

  final String image;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(image),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_right_sharp,
        size: 32,
      ),
    );
  }
}
