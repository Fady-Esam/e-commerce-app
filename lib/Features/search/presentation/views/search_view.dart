import 'package:ewsrtes/core/cubits/product_model_cubit/product_model_state.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:ewsrtes/core/widgets/image_and_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/product_model_cubit/product_model_cubit.dart';
import 'widgets/search_items_grid_view.dart';

class SearchView extends StatefulWidget {
  const SearchView(
      {super.key,
      this.ctgsProducts,
      this.ctgName,
      this.isFromCategory = false});

  final List<ProductModel>? ctgsProducts;
  final String? ctgName;
  final bool isFromCategory;
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var controller = TextEditingController();
  List<ProductModel> products = [];
  List<ProductModel> searchedProduts = [];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.isFromCategory ? true : false,
        title: ImageAndShimmer(
          text: widget.ctgsProducts == null
              ? 'Search'
              : widget.ctgName.toString(),
        ),
      ),
      body: widget.ctgsProducts == null ||
              (widget.ctgsProducts != null && widget.ctgsProducts!.isNotEmpty)
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  TextField(
                    controller: controller,
                    onChanged: widget.ctgsProducts == null
                        ? (value) {
                            searchedProduts = products
                                .where((e) => e.productCategory
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                            setState(() {});
                          }
                        : (value) {
                            searchedProduts = widget.ctgsProducts!
                                .where((e) => e.productTitle
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                            setState(() {});
                          },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.clear();
                          FocusScope.of(context).unfocus();
                          searchedProduts = [];
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                      hintText: widget.isFromCategory ? 'Model' : 'Category',
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      labelText: 'Search',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: BlocBuilder<ProductModelCubit, ProductModelState>(
                      builder: (context, state) {
                        products = BlocProvider.of<ProductModelCubit>(context)
                            .products;
                        return SearchItemsGridView(
                            widget: widget,
                            searchedProduts: searchedProduts,
                            products: products,
                            isFromCategory: widget.isFromCategory);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            )
          : const Center(
              child: Text(
                'No Products to display',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
    );
  }
}
