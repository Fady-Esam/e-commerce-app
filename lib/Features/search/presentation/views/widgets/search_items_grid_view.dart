import 'package:flutter/material.dart';

import '../../../../../core/models/product_model.dart';
import '../search_view.dart';
import 'product_item.dart';

class SearchItemsGridView extends StatelessWidget {
  const SearchItemsGridView({
    super.key,
    required this.widget,
    required this.searchedProduts,
    required this.products, 
    required this.isFromCategory,
  });

  final SearchView widget;
  final List<ProductModel> searchedProduts;
  final List<ProductModel> products;
  final bool isFromCategory;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.ctgsProducts == null &&
              searchedProduts.isEmpty
          ? products.length
          : searchedProduts.isNotEmpty
              ? searchedProduts.length
              : widget.ctgsProducts!.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1 / 1.6,
      ),
      itemBuilder: (context, index) {
        return ProductItem(
          isFromCategory: widget.isFromCategory,
          productModel: widget.ctgsProducts == null &&
                  searchedProduts.isEmpty
              ? products[index]
              : searchedProduts.isNotEmpty
                  ? searchedProduts[index]
                  : widget.ctgsProducts![index],
        );
      },
    );
  }
}
