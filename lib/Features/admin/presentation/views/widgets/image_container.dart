import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../add_or__edit_product_view.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.widget,
    required this.pickedImage,
  });

  final AddOrEditProduct widget;
  final File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: pickedImage == null && !widget.isEditing
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'users_assets/assets/images/empty.png',
                fit: BoxFit.fill,
              ),
            )
          : widget.isEditing && pickedImage == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.productModel !=null? CachedNetworkImage(
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) {
                      return const Icon(
                        Icons.error,
                      );
                    },
                    placeholder: (context, url) {
                      return const Center(child: CircularProgressIndicator());
                    },
                    imageUrl: widget.productModel!.productImage,
                  ):const Center(child: CircularProgressIndicator()),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    pickedImage!,
                    fit: BoxFit.fill,
                  ),
                ),
    );
  }
}
