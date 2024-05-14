import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewsrtes/Features/cart/data/models/order_model.dart';
import 'package:ewsrtes/Features/cart/presentation/manager/cubits/order_model_cubit/order_model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.orderModel});

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, right: 12, left: 12, bottom: 16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                width: MediaQuery.sizeOf(context).width * 0.4,
                height: MediaQuery.sizeOf(context).height * 0.17,
                errorWidget: (context, url, error) {
                  return const Icon(Icons.error);
                },
                placeholder: (context, url) {
                  return const Center(child: CircularProgressIndicator());
                },
                imageUrl: orderModel.imageUrl,
              ),
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.35,
                  ),
                  child: Text(
                    orderModel.productTitle,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '\$${orderModel.price}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${orderModel.quantity}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                BlocProvider.of<OrderModelCubit>(context).deleteOrder(
                  orderId: orderModel.orderId,
                );
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
