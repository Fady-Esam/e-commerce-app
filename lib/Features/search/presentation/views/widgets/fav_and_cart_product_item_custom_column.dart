import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import '../../../../../core/functions/show_warning_message_fun.dart';
import 'product_item.dart';

class FavAndCartProductItemCustomColumn extends StatelessWidget {
  const FavAndCartProductItemCustomColumn({
    super.key,
    required this.widget,
  });

  final ProductItem widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!BlocProvider.of<CartsAndWishListCubit>(context).isInWishList(
          productId: widget.productModel.productId,
        ))
          IconButton(
            onPressed: () {
              if (FirebaseAuth.instance.currentUser == null) {
                showWarningMessageFun(
                  context: context,
                  text:
                      'You are a guest please log in to be able to add products in your Favorites',
                );
              }else{
                BlocProvider.of<CartsAndWishListCubit>(context).addToWishList(
                  productModel: widget.productModel,
                );
              }
            },
            icon: const Icon(
              Icons.favorite,
            ),
          )
        else
          IconButton(
            onPressed: () {
              BlocProvider.of<CartsAndWishListCubit>(context).removeFromWishList(
                productModel: widget.productModel,
              );
            },
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        if (!BlocProvider.of<CartsAndWishListCubit>(context).isProductInCart(
          productId: widget.productModel.productId,
        ))
          InkWell(
            onTap: () {
              if (FirebaseAuth.instance.currentUser == null) {
                showWarningMessageFun(
                  context: context,
                  text:
                      'You are a guest please log in to be able to add products in your cart',
                );
              } else {
                BlocProvider.of<CartsAndWishListCubit>(context).addToCart(
                  productId: widget.productModel.productId,
                  quantity: '1',
                );
              }
            },
            child: const Material(
              elevation: 3,
              child: Icon(
                Icons.shopping_cart,
              ),
            ),
          )
        else
          const Icon(
            Ionicons.checkmark_done,
          ),
      ],
    );
  }
}
