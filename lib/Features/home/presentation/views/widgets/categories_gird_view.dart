

import 'package:flutter/material.dart';

import '../../../data/models/category_item_model.dart';
import 'home_category_item.dart';

class CategoriesGridView extends StatelessWidget {
  const CategoriesGridView({
    super.key,
    required this.catgoriesItems,
  });

  final List<CategoryItemModel> catgoriesItems;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 15,
      ),
      itemCount: catgoriesItems.length,
      itemBuilder: (context, index) {
        return HomeCategoryItem(categoryItem: catgoriesItems[index]);
      },
    );
  }
}
