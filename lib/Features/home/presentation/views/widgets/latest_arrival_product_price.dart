import 'package:flutter/material.dart';

import 'home_latest_arrival_item.dart';

class LatestArrivalProductPrice extends StatelessWidget {
  const LatestArrivalProductPrice({
    super.key,
    required this.widget,
  });

  final HomeLatestArrivalItem widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${widget.productModel.productPrice}',
      style: const TextStyle(
        fontSize: 18,
        overflow: TextOverflow.ellipsis,
        color: Colors.blue,
      ),
    );
  }
}
