import 'package:ewsrtes/core/cubits/product_model_cubit/product_model_state.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/product_model_cubit/product_model_cubit.dart';
import 'widgets/inspect_product_item.dart';

class InspectAllProductsView extends StatefulWidget {
  const InspectAllProductsView({super.key});
  @override
  State<InspectAllProductsView> createState() => _InspectAllProductsViewState();
}

class _InspectAllProductsViewState extends State<InspectAllProductsView> {
  var controller = TextEditingController();
  List<ProductModel> products = [];
  List<ProductModel> searchedProduts = [];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'admin_assets/assets/images/shopping_cart.png',
              height: 55,
            ),
            const SizedBox(width: 12),
            // ignore: prefer_const_constructors
            Text(
              'Store Products',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: products.isNotEmpty ||
              searchedProduts.isNotEmpty ||
              BlocProvider.of<ProductModelCubit>(context).products.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  TextField(
                    controller: controller,
                    onChanged: (value) {
                      searchedProduts = products
                          .where((e) => e.productCategory
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
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      hintText: 'Category',
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
                        return GridView.builder(
                          itemCount: searchedProduts.isEmpty
                              ? products.length
                              : searchedProduts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1 / 1.6,
                          ),
                          itemBuilder: (context, index) {
                            return InspectProductItem(
                              productModel: searchedProduts.isEmpty
                                  ? products[index]
                                  : searchedProduts[index],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
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
