import 'package:ewsrtes/Features/admin/presentation/views/functions/show_option_dialog.dart';
import 'package:ewsrtes/Features/cart/presentation/views/widgets/bottom_checkout.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import 'package:ewsrtes/core/cubits/guest_cubit/guest_cubit.dart';
import 'package:ewsrtes/core/widgets/image_and_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/functions/show_snack_bar_fun.dart';
import '../../../../core/widgets/empty_bag.dart';
import 'widgets/carts_items_list_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void fetchCarts() async {
    BlocProvider.of<CartsAndWishListCubit>(context).fetchCarts();
  }

  List<dynamic> carts = [];

  @override
  void initState() {
    super.initState();
    fetchCarts();
    BlocProvider.of<CartsAndWishListCubit>(context).getTotal(context: context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<CartsAndWishListCubit, CartsAndWishListState>(
      listener: (context, state) {
        if (state is WishListCubitFailedAdded) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
            context: context,
            text: 'Failed to add to favorites, Please try again',
          );
        } else if (state is CartModelSuccessRemoveOneItem) {
          BlocProvider.of<CartsAndWishListCubit>(context)
              .getTotal(context: context);
        } else if (state is CartModelSuccessRemovedAllItems) {
          BlocProvider.of<CartsAndWishListCubit>(context)
              .getTotal(context: context);
        } else if (state is CartModelSuccessUpdateQuantity) {
          BlocProvider.of<CartsAndWishListCubit>(context)
              .getTotal(context: context);
        }
      },
      builder: (context, state) {
        carts = BlocProvider.of<CartsAndWishListCubit>(context).carts;
        return Scaffold(
          bottomSheet: !BlocProvider.of<GuestCubit>(context).isUserGuest &&
                  carts.isNotEmpty
              ? const BottomCheckout()
              : null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const ImageAndShimmer(text: 'Shopping Carts'),
                const Spacer(),
                if (!BlocProvider.of<GuestCubit>(context).isUserGuest &&
                    carts.isNotEmpty)
                  IconButton(
                    onPressed: () async {
                      await showOptionDialog(
                        context: context,
                        warningText: 'Are you Sure to clear your Carts?',
                        onYesPress: () async {
                          Navigator.pop(context);
                          await BlocProvider.of<CartsAndWishListCubit>(context)
                              .clearCart();
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
          body: carts.isEmpty
              ? EmptyBag(
                  image: 'admin_assets/assets/images/shopping_cart.png',
                  title: 'Whoops',
                  subtitle: 'Your Cart Is Empty',
                  content:
                      'Look, you have not added anything, You Can${BlocProvider.of<GuestCubit>(context).isUserGuest ? ' Log In and ' : ' '}Shop Now!',
                )
              : CartsItemsListView(carts: carts),
        );
      },
    );
  }
}
