import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import 'package:ewsrtes/core/functions/show_snack_bar_fun.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import '../../../../../core/views/product_item_details_view.dart';
import '../../../../profile/presentation/manager/cubits/viewed_recently_cubit/viewed_recentely_cubit.dart';
import 'details_product_item_custom_column.dart';
import 'fav_and_cart_product_item_custom_column.dart';

class ProductItem extends StatefulWidget {
  const ProductItem(
      {super.key, required this.productModel, required this.isFromCategory});

  final ProductModel productModel;
  final bool isFromCategory;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductItemDetailsView(productModel: widget.productModel),
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
                    fit: BoxFit.fill,
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    errorWidget: (context, url, error) {
                      return const Icon(Icons.error);
                    },
                    placeholder: (context, url) {
                      return const Center(child: CircularProgressIndicator());
                    },
                    imageUrl: widget.productModel.productImage,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    DetailsProductItemCustomColumn(
                        widget: widget, isFromCategory: widget.isFromCategory),
                    const Spacer(),
                    FavAndCartProductItemCustomColumn(widget: widget),
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
