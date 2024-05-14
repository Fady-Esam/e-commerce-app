import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuantityBottomSheet extends StatefulWidget {
  const QuantityBottomSheet({super.key, required this.productModel});

  final ProductModel productModel;

  @override
  State<QuantityBottomSheet> createState() => _QuantityBottomSheetState();
}

class _QuantityBottomSheetState extends State<QuantityBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey,
          ),
          alignment: Alignment.center,
          height: 10,
          width: 100,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  BlocProvider.of<CartsAndWishListCubit>(context)
                      .updateQuantity(
                    productId: widget.productModel.productId,
                    quantity: (index + 1).toString(),
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
