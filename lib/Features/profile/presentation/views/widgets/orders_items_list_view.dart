import 'package:flutter/material.dart';

import 'order_item.dart';

class OrdersItemsListView extends StatelessWidget {
  const OrdersItemsListView({
    super.key,
    required this.orders,
  });

  final List orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return OrderItem(orderModel: orders[index]);
      },
      separatorBuilder: (context, index) =>
          const Divider(thickness: 2),
      itemCount: orders.length,
    );
  }
}
