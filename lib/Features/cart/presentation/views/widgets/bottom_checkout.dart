import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewsrtes/Features/admin/presentation/views/functions/show_option_dialog.dart';
import 'package:ewsrtes/Features/cart/presentation/manager/cubits/order_model_cubit/order_model_cubit.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import 'package:ewsrtes/core/cubits/product_model_cubit/product_model_cubit.dart';
import 'package:ewsrtes/core/cubits/user_data_cubit/user_data_cubit.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:ewsrtes/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';

class BottomCheckout extends StatefulWidget {
  const BottomCheckout({super.key});

  @override
  State<BottomCheckout> createState() => _BottomCheckoutState();
}

class _BottomCheckoutState extends State<BottomCheckout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CartsAndWishListCubit, CartsAndWishListState>(
                builder: (context, state) {
                  int length = BlocProvider.of<CartsAndWishListCubit>(context)
                      .carts
                      .length;
                  return Text(
                    'Total ($length Products)',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  );
                },
              ),
              BlocBuilder<CartsAndWishListCubit, CartsAndWishListState>(
                builder: (context, state) {
                  double total =
                      BlocProvider.of<CartsAndWishListCubit>(context).total;
                  return Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () async {
              await showOptionDialog(
                context: context,
                warningText: 'Are you Sure to Check Out?',
                onYesPress: () async {
                  Navigator.pop(context);
                  UserModel userData =
                      await BlocProvider.of<UserDataCubit>(context)
                          .fetchUserData(
                              id: FirebaseAuth.instance.currentUser!.uid);
                  BlocProvider.of<CartsAndWishListCubit>(context)
                      .carts
                      .forEach((e) async {
                    ProductModel? producModel =
                        BlocProvider.of<ProductModelCubit>(context)
                            .getCurrentProductById(productId: e.productId);
                    await BlocProvider.of<OrderModelCubit>(context).sendOrders(
                      orderId: const Uuid().v4(),
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      productId: e.productId,
                      productTitle: producModel!.productTitle,
                      userName: userData.userName,
                      price: producModel.productPrice,
                      imageUrl: producModel.productImage,
                      quantity: e.quantity,
                      orderDate: Timestamp.now(),
                    );
                  });
                  await BlocProvider.of<CartsAndWishListCubit>(context)
                      .clearCart();
                },
              );
            },
            child: const Text(
              'Check Out',
              style: TextStyle(
                fontSize: 19,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
