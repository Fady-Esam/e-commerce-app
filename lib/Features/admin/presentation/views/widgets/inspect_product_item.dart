import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/models/product_model.dart';
import '../add_or__edit_product_view.dart';

class InspectProductItem extends StatefulWidget {
  const InspectProductItem({super.key, required this.productModel});

  final ProductModel productModel;

  @override
  State<InspectProductItem> createState() => _InspectProductItemState();
}

class _InspectProductItemState extends State<InspectProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddOrEditProduct(
              isEditing: true,
              productModel: widget.productModel,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                width: MediaQuery.sizeOf(context).width * 0.35,
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
            const SizedBox(height: 14),
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
                style: const TextStyle(
                  fontSize: 19,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              '\$${widget.productModel.productPrice}',
              style: const TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
