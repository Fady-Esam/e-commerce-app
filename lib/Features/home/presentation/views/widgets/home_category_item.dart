import 'package:ewsrtes/Features/search/presentation/views/search_view.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/cubits/product_model_cubit/product_model_cubit.dart';
import '../../../data/models/category_item_model.dart';

class HomeCategoryItem extends StatefulWidget {
  const HomeCategoryItem({super.key, required this.categoryItem});

  final CategoryItemModel categoryItem;

  @override
  State<HomeCategoryItem> createState() => _HomeCategoryItemState();
}

class _HomeCategoryItemState extends State<HomeCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        List<ProductModel>? ctgsList =
            BlocProvider.of<ProductModelCubit>(context)
                .getCtgsPoducts(ctgName: widget.categoryItem.name);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchView(
              ctgsProducts: ctgsList,
              ctgName: widget.categoryItem.name,
              isFromCategory: true,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Image.asset(
            widget.categoryItem.image,
            height: 45,
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 100,
            ),
            child: Text(
              widget.categoryItem.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
