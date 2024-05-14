import 'package:ewsrtes/Features/cart/presentation/manager/cubits/order_model_cubit/order_model_cubit.dart';
import 'package:ewsrtes/Features/cart/presentation/manager/cubits/order_model_cubit/order_model_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/functions/show_snack_bar_fun.dart';
import '../../../profile/presentation/views/widgets/order_item.dart';
import 'functions/show_option_dialog.dart';

class OrdersAdminView extends StatefulWidget {
  const OrdersAdminView({super.key});

  @override
  State<OrdersAdminView> createState() => _OrdersAdminViewState();
}

class _OrdersAdminViewState extends State<OrdersAdminView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderModelCubit>(context).fetchAllOrders();
  }

  List<dynamic> orders = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderModelCubit, OrderModelState>(
      listener: (context, state) {
        if (state is OrderModelLoadingClearAllOrders) {
          Navigator.pop(context);
          isLoading = true;
        } else if (state is OrderModelSuccessClearAllOrders) {
          isLoading = false;
        } else if (state is OrderModelFailureClearAllOrders) {
          isLoading = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBarFun(
            context: context,
            text: 'Failed to clear orders, Please try again',
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Text(
                    'Placed Orders',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      await showOptionDialog(
                        context: context,
                        warningText: 'Are you Sure to clear All your Orders?',
                        onYesPress: () async {
                          await BlocProvider.of<OrderModelCubit>(context)
                              .clearAllOrders();
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
            body: BlocBuilder<OrderModelCubit, OrderModelState>(
              builder: (context, state) {
                orders = BlocProvider.of<OrderModelCubit>(context).allOrders;
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return OrderItem(orderModel: orders[index]);
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(thickness: 2),
                  itemCount: orders.length,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
