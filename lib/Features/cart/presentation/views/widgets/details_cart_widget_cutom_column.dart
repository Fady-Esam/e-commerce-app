import 'package:flutter/material.dart';

import '../../../../../core/models/product_model.dart';
import 'cart_widget.dart';
import 'quantity_bottom_sheet.dart';

class DetailsCartWidgetCustomColumn extends StatelessWidget {
  const DetailsCartWidgetCustomColumn({
    super.key,
    required this.productModel,
    required this.widget,
  });

  final ProductModel? productModel;
  final CartWidget widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.35,
          ),
          child: Text(
            productModel!.productTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Text(
          '\$${productModel!.productPrice}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              builder: (context) => QuantityBottomSheet(
                productModel: productModel!,
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_downward,
            color: Colors.blue,
          ),
          label: Text(
            'Qty: ${widget.cartModel.quantity}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
