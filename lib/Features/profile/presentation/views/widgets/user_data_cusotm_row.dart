import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/models/user_model.dart';

class UserDataCustomRow extends StatelessWidget {
  const UserDataCustomRow({
    super.key,
    required this.userModel,
  });

  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        userModel != null
            ? CircleAvatar(
                radius: 44,
                backgroundColor: Colors.blue,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    imageUrl: userModel!.userImage,
                    fit: BoxFit.fill,
                    height: 80,
                    width: 80,
                    errorWidget: (context, url, error) {
                      return const Icon(
                        Icons.error,
                      );
                    },
                    placeholder: (context, url) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
        const SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.65,
              ),
              child: Text(
                userModel?.userName ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.65,
              ),
              child: Text(
                userModel?.userEmail ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
