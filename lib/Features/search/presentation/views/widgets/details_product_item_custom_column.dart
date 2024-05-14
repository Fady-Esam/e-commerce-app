import 'package:flutter/material.dart';

import 'product_item.dart';

class DetailsProductItemCustomColumn extends StatelessWidget {
  const DetailsProductItemCustomColumn({
    super.key,
    required this.widget,
    required this.isFromCategory,
  });

  final ProductItem widget;
  final bool isFromCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFromCategory)
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 120,
            ),
            child: Text(
              widget.productModel.productCategory,
              style: const TextStyle(
                fontSize: 19,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 120,
          ),
          child: Text(
            widget.productModel.productTitle,
            maxLines: isFromCategory ? 2 : 1,
            style: const TextStyle(
              fontSize: 19,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (isFromCategory) const SizedBox(height: 8),
        Text(
          '\$${widget.productModel.productPrice}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
