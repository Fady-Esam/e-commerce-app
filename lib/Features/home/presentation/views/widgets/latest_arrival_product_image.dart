import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'home_latest_arrival_item.dart';

class LatestArrivalProductImage extends StatelessWidget {
  const LatestArrivalProductImage({
    super.key,
    required this.widget,
  });

  final HomeLatestArrivalItem widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        height: double.infinity,
        errorWidget: (context, url, error) {
          return const Icon(Icons.error);
        },
        placeholder: (context, url) {
          return const Center(child: CircularProgressIndicator());
        },
        imageUrl: widget.productModel.productImage,
      ),
    );
  }
}
