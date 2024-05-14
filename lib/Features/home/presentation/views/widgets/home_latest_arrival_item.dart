import 'package:ewsrtes/Features/profile/presentation/manager/cubits/viewed_recently_cubit/viewed_recentely_cubit.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import 'package:ewsrtes/core/functions/show_snack_bar_fun.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../core/functions/show_warning_message_fun.dart';
import '../../../../../core/views/product_item_details_view.dart';
import 'latest_arrival_product_image.dart';
import 'latest_arrival_product_price.dart';
import 'latest_arrival_product_title.dart';

class HomeLatestArrivalItem extends StatefulWidget {
  const HomeLatestArrivalItem({super.key, required this.productModel});

  final ProductModel productModel;

  @override
  State<HomeLatestArrivalItem> createState() => _HomeLatestArrivalItemState();
}

class _HomeLatestArrivalItemState extends State<HomeLatestArrivalItem> {
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
              text: 'Failed to add to Carts, Please try again',
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
            width: MediaQuery.sizeOf(context).width * 0.52,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: LatestArrivalProductImage(widget: widget),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LatestArrivalProductTitle(widget: widget),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!BlocProvider.of<CartsAndWishListCubit>(context)
                              .isProductInCart(
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
                                  BlocProvider.of<CartsAndWishListCubit>(
                                          context)
                                      .addToCart(
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
                          if (!BlocProvider.of<CartsAndWishListCubit>(context)
                              .isInWishList(
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
                                }
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
                        ],
                      ),
                      LatestArrivalProductPrice(widget: widget),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
