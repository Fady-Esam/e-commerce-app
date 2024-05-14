import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import '../../../../../core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import '../../../../../core/functions/show_snack_bar_fun.dart';
import '../../../../../core/functions/show_warning_message_fun.dart';

class ProductViewedRecentlyItem extends StatelessWidget {
  const ProductViewedRecentlyItem({super.key, required this.productModel});

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartsAndWishListCubit, CartsAndWishListState>(
      listener: (context, state) {
        if (state is CartModelSuccessAddedToCart) {
          BlocProvider.of<CartsAndWishListCubit>(context)
              .getTotal(context: context);
        } else if (state is CartModelFailureAddedToCart) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
            context: context,
            text: 'Failed to add to Cart, Please try again',
          );
        } else if (state is WishListCubitFailedAdded) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
            context: context,
            text: 'Failed to add to favorites, Please try again',
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: MediaQuery.sizeOf(context).height * 0.23,
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error);
                  },
                  placeholder: (context, url) {
                    return const Center(child: CircularProgressIndicator());
                  },
                  imageUrl: productModel.productImage,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 120,
                        ),
                        child: Text(
                          productModel.productCategory,
                          style: const TextStyle(
                            fontSize: 19,
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 120,
                        ),
                        child: Text(
                          productModel.productTitle,
                          style: const TextStyle(
                            fontSize: 19,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        '\$${productModel.productPrice}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      if (!BlocProvider.of<CartsAndWishListCubit>(context)
                          .isInWishList(
                        productId: productModel.productId,
                      ))
                        IconButton(
                          onPressed: () {
                            if (FirebaseAuth.instance.currentUser == null) {
                              showWarningMessageFun(
                                context: context,
                                text:
                                    'You are a guest please log in to be able to add products in your Favorites',
                              );
                            }
                            BlocProvider.of<CartsAndWishListCubit>(context)
                                .addToWishList(
                              productModel: productModel,
                            );
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
                              productModel: productModel,
                            );
                          },
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      if (!BlocProvider.of<CartsAndWishListCubit>(context)
                          .isProductInCart(
                        productId: productModel.productId,
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
                              BlocProvider.of<CartsAndWishListCubit>(context)
                                  .addToCart(
                                productId: productModel.productId,
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
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
