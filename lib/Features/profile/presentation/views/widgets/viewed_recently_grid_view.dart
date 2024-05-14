
import 'package:flutter/material.dart';

import '../../../../../core/models/product_model.dart';
import 'product_viewed_recently_item.dart';

class ViewedRecentlyGridView extends StatelessWidget {
  const ViewedRecentlyGridView({
    super.key,
    required this.viewedRecentlyList,
  });

  final List<ProductModel> viewedRecentlyList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: viewedRecentlyList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
        childAspectRatio: 1 / 1.7,
      ),
      itemBuilder: (context, index) {
        return ProductViewedRecentlyItem(
          productModel: viewedRecentlyList[index],
        );
      },
    );
  }
}
