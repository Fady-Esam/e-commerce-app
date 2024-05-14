import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/product_model.dart';
import 'cart_widget.dart';

class FavAndDeleteCartWidgetCustomColumn extends StatefulWidget {
  const FavAndDeleteCartWidgetCustomColumn({
    super.key,
    required this.productModel,
    required this.widget,
  });

  final ProductModel? productModel;
  final CartWidget widget;

  @override
  State<FavAndDeleteCartWidgetCustomColumn> createState() =>
      _FavAndDeleteCartWidgetCustomColumnState();
}

class _FavAndDeleteCartWidgetCustomColumnState
    extends State<FavAndDeleteCartWidgetCustomColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () async {
            await BlocProvider.of<CartsAndWishListCubit>(context).removeOneItem(
              productId: widget.widget.cartModel.productId,
              quantity: widget.widget.cartModel.quantity.toString(),
              cartId: widget.widget.cartModel.cartId,
            );
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        if (!BlocProvider.of<CartsAndWishListCubit>(context).isInWishList(
          productId: widget.productModel!.productId,
        ))
          IconButton(
            onPressed: () {
              BlocProvider.of<CartsAndWishListCubit>(context)
                  .addToWishList(productModel: widget.productModel!);
            },
            icon: const Icon(
              Icons.favorite,
            ),
          )
        else
          IconButton(
            onPressed: () {
              BlocProvider.of<CartsAndWishListCubit>(context)
                  .removeFromWishList(
                productModel: widget.productModel!,
              );
            },
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
