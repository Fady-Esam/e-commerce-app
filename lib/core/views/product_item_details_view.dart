import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:ewsrtes/core/widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../functions/show_snack_bar_fun.dart';
import '../widgets/fav_and_cart_details.dart';
import '../widgets/title_and_price_details.dart';

class ProductItemDetailsView extends StatefulWidget {
  const ProductItemDetailsView({
    super.key,
    required this.productModel,
  });

  final ProductModel productModel;

  @override
  State<ProductItemDetailsView> createState() => _ProductItemDetailsViewState();
}

class _ProductItemDetailsViewState extends State<ProductItemDetailsView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartsAndWishListCubit, CartsAndWishListState>(
      listener: (context, state) {
        if (state is CartModelFailureAddedToCart) {
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
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const CustomShimmer(text: 'ShopSmart'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Material(
                  color: const Color.fromARGB(255, 173, 208, 237),
                  elevation: 5,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.badge,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.error);
                        },
                        placeholder: (context, url) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        imageUrl: widget.productModel.productImage,
                      )),
                  const SizedBox(height: 24),
                  TitleAndPriceDetails(widget: widget),
                  const SizedBox(height: 24),
                  FavAndCartDetails(widget: widget),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'About this item',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.productModel.productCategory,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.productModel.productDescription,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
