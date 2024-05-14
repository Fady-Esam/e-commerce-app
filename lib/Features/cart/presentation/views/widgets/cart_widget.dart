import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewsrtes/core/cubits/product_model_cubit/product_model_cubit.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:ewsrtes/core/views/product_item_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/cart_model.dart';
import '../../../../profile/presentation/manager/cubits/viewed_recently_cubit/viewed_recentely_cubit.dart';
import 'details_cart_widget_cutom_column.dart';
import 'fav_and_delete_cart_widget_cusom_column.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key, required this.cartModel});

  final CartModel cartModel;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    ProductModel? productModel =
        BlocProvider.of<ProductModelCubit>(context).getCurrentProductById(
      productId: widget.cartModel.productId,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 18, right: 12, left: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductItemDetailsView(
                productModel: productModel!,
              ),
            ),
          );
          if (!BlocProvider.of<ViewedRecentelyCubit>(context).isViewedRecently(
            producMOdel: productModel!,
          )) {
            BlocProvider.of<ViewedRecentelyCubit>(context)
                .addToViewedRecentely(producMOdel: productModel);
          }
        },
        child: IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: productModel != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          height: MediaQuery.sizeOf(context).height * 0.16,
                          fit: BoxFit.fill,
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.error);
                          },
                          placeholder: (context, url) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          imageUrl: productModel.productImage,
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(width: 18),
              DetailsCartWidgetCustomColumn(
                productModel: productModel,
                widget: widget,
              ),
              const Spacer(),
              FavAndDeleteCartWidgetCustomColumn(
                productModel: productModel,
                widget: widget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
