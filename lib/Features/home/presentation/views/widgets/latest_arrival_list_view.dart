

import 'package:flutter/material.dart';

import '../../../../../core/models/product_model.dart';
import 'home_latest_arrival_item.dart';

class LatestArrivalListView extends StatelessWidget {
  const LatestArrivalListView({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return HomeLatestArrivalItem(
          productModel: products[index],
        );
      },
    );
  }
}