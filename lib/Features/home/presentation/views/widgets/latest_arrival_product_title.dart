import 'package:flutter/material.dart';

import 'home_latest_arrival_item.dart';

class LatestArrivalProductTitle extends StatelessWidget {
  const LatestArrivalProductTitle({
    super.key,
    required this.widget,
  });

  final HomeLatestArrivalItem widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.productModel.productTitle,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 19,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
