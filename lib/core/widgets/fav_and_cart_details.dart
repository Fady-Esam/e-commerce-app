import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import '../functions/show_warning_message_fun.dart';
import '../views/product_item_details_view.dart';

class FavAndCartDetails extends StatelessWidget {
  const FavAndCartDetails({
    super.key,
    required this.widget,
  });

  final ProductItemDetailsView widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: const Color.fromARGB(255, 173, 208, 237),
          borderRadius: BorderRadius.circular(22),
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(1),
              child:
                  !BlocProvider.of<CartsAndWishListCubit>(context).isInWishList(
                productId: widget.productModel.productId,
              )
                      ? IconButton(
                          onPressed: () {
                            if (FirebaseAuth.instance.currentUser == null) {
                              showWarningMessageFun(
                                context: context,
                                text:
                                    'You are a guest please log in to be able to add products in your favorites',
                              );
                            }else{
                              BlocProvider.of<CartsAndWishListCubit>(context)
                                  .addToWishList(
                                productModel: widget.productModel,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.favorite,
                            size: 32,
                            color: Colors.white,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            BlocProvider.of<CartsAndWishListCubit>(context)
                                .removeFromWishList(
                              productModel: widget.productModel,
                            );
                          },
                          icon: const Icon(
                            Icons.favorite,
                            size: 32,
                            color: Colors.red,
                          ),
                        )),
        ),
        const SizedBox(
          width: 12,
        ),
        !BlocProvider.of<CartsAndWishListCubit>(context)
                .isProductInCart(productId: widget.productModel.productId)
            ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Transform.translate(
                  offset: Offset(MediaQuery.sizeOf(context).width * 0.1, 0),
                  child: const Icon(
                    Icons.add,
                    size: 28,
                  ),
                ),
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    showWarningMessageFun(
                      context: context,
                      text:
                          'You are a guest please log in to be able to add products in your cart',
                    );
                  } else {
                    await BlocProvider.of<CartsAndWishListCubit>(context)
                        .addToCart(
                      productId: widget.productModel.productId,
                      quantity: '1',
                    );
                  }
                },
                label: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 6,
                  ),
                  child: Text(
                    'add to cart',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            : const Icon(
                Ionicons.checkmark_done,
              ),
      ],
    );
  }
}
