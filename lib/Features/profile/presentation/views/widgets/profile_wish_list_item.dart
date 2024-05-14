import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:ewsrtes/core/views/product_item_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import '../../../../../core/functions/show_snack_bar_fun.dart';
import '../../manager/cubits/viewed_recently_cubit/viewed_recentely_cubit.dart';

class ProductWishListItem extends StatefulWidget {
  const ProductWishListItem({super.key, required this.productModel});

  final ProductModel productModel;

  @override
  State<ProductWishListItem> createState() => _ProductWishListItemState();
}

class _ProductWishListItemState extends State<ProductWishListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductItemDetailsView(
              productModel: widget.productModel,
            ),
          ),
        );
        if (!BlocProvider.of<ViewedRecentelyCubit>(context)
            .isViewedRecently(producMOdel: widget.productModel)) {
          BlocProvider.of<ViewedRecentelyCubit>(context)
              .addToViewedRecentely(producMOdel: widget.productModel);
        }
      },
      child: BlocConsumer<CartsAndWishListCubit, CartsAndWishListState>(
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
                    imageUrl: widget.productModel.productImage,
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
                            widget.productModel.productCategory,
                            overflow: TextOverflow.ellipsis,
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
                            widget.productModel.productTitle,
                            style: const TextStyle(
                              fontSize: 19,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Text(
                          '\$${widget.productModel.productPrice}',
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
                          productId: widget.productModel.productId,
                        ))
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<CartsAndWishListCubit>(context)
                                  .addToWishList(
                                productModel: widget.productModel,
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
                                productModel: widget.productModel,
                              );
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                        if (!BlocProvider.of<CartsAndWishListCubit>(context)
                            .isProductInCart(
                          productId: widget.productModel.productId,
                        ))
                          InkWell(
                            onTap: () {
                              BlocProvider.of<CartsAndWishListCubit>(context)
                                  .addToCart(
                                productId: widget.productModel.productId,
                                quantity: '1',
                              );
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
      ),
    );
  }
}
