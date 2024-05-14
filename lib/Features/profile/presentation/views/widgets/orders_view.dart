import 'package:ewsrtes/Features/admin/presentation/views/functions/show_option_dialog.dart';
import 'package:ewsrtes/Features/cart/presentation/manager/cubits/order_model_cubit/order_model_cubit.dart';
import 'package:ewsrtes/Features/cart/presentation/manager/cubits/order_model_cubit/order_model_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/cubits/guest_cubit/guest_cubit.dart';

import '../../../../../core/functions/show_snack_bar_fun.dart';
import '../../../../../core/widgets/empty_bag.dart';
import '../../../../../core/widgets/image_and_shimmer.dart';
import 'orders_items_list_view.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  List<dynamic> orders = [];
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    BlocProvider.of<OrderModelCubit>(context)
        .fetchOrders(userId: FirebaseAuth.instance.currentUser!.uid);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderModelCubit, OrderModelState>(
      listener: (context, state) {
        if (state is OrderModelLoadingClearOrdersForUser) {
          Navigator.pop(context);
          isLoading = true;
        } else if (state is OrderModelSuccessClearOrdersForUser) {
          isLoading = false;
        } else if (state is OrderModelFailureClearOrdersForUser) {
          isLoading = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
            context: context,
            text: 'Failed to clear orders, Please try again',
          );
        }
      },
      builder: (context, state) {
        orders = BlocProvider.of<OrderModelCubit>(context).ordersList;
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const ImageAndShimmer(text: 'Placed Orders'),
                  const Spacer(),
                  if (!BlocProvider.of<GuestCubit>(context).isUserGuest &&
                      orders.isNotEmpty)
                    IconButton(
                      onPressed: () async {
                        await showOptionDialog(
                          context: context,
                          warningText: 'Are you Sure to clear All your Orders?',
                          onYesPress: () async {
                            await BlocProvider.of<OrderModelCubit>(context)
                                .clearUserOrders();
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
            body: orders.isEmpty
                ? EmptyBag(
                    image: 'admin_assets/assets/images/shopping_cart.png',
                    title: 'Whoops',
                    subtitle: 'Your Placed Orders Is Empty',
                    content:
                        'Look you have not added anything, You Can${BlocProvider.of<GuestCubit>(context).isUserGuest ? ' Log In and ' : ' '}Shop Now to Add to your Orders!',
                  )
                : OrdersItemsListView(orders: orders),
          ),
        );
      },
    );
  }
}
