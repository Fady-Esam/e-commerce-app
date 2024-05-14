import 'package:flutter/material.dart';

import 'profile_wish_list_item.dart';

class WishListItemsGridView extends StatelessWidget {
  const WishListItemsGridView({
    super.key,
    required this.wishListProducts,
  });

  final List wishListProducts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: wishListProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1 / 1.7,
      ),
      itemBuilder: (context, index) {
        return ProductWishListItem(productModel: wishListProducts[index]);
      },
    );
  }
}
