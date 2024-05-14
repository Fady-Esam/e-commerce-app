import 'package:flutter/material.dart';

import 'cart_widget.dart';

class CartsItemsListView extends StatelessWidget {
  const CartsItemsListView({
    super.key,
    required this.carts,
  });

  final List carts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: carts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == carts.length - 1 ? 100 : 0,
          ),
          child: CartWidget(
            cartModel: carts[index],
          ),
        );
      },
    );
  }
}
