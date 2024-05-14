import 'package:ewsrtes/Features/admin/presentation/views/functions/show_option_dialog.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import 'package:ewsrtes/core/cubits/guest_cubit/guest_cubit.dart';
import 'package:ewsrtes/core/widgets/image_and_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import 'widgets/wish_list_items_grid_view.dart';

class ProfileWishListView extends StatefulWidget {
  const ProfileWishListView({super.key});

  @override
  State<ProfileWishListView> createState() => _ProfileWishListViewState();
}

class _ProfileWishListViewState extends State<ProfileWishListView> {
  List<dynamic> wishListProducts = [];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartsAndWishListCubit>(context).fetchWishList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartsAndWishListCubit, CartsAndWishListState>(
      builder: (context, state) {
        wishListProducts =
            BlocProvider.of<CartsAndWishListCubit>(context).wishListProducts;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const ImageAndShimmer(text: 'Favorites'),
                const Spacer(),
                if (!BlocProvider.of<GuestCubit>(context).isUserGuest &&
                    wishListProducts.isNotEmpty)
                  IconButton(
                    onPressed: () async {
                      await showOptionDialog(
                        context: context,
                        warningText:
                            'Are you Sure to clear all your Favorites?',
                        onYesPress: () async {
                          Navigator.pop(context);
                          await BlocProvider.of<CartsAndWishListCubit>(context)
                              .clearWishList();
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      size: 30,
                    ),
                  ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 22),
                Expanded(
                  child: WishListItemsGridView(
                    wishListProducts: wishListProducts,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
