import 'package:ewsrtes/core/cubits/product_model_cubit/product_model_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/product_model_cubit/product_model_cubit.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/widgets/image_and_shimmer.dart';
import '../../data/categories_items_list.dart';
import 'widgets/categories_gird_view.dart';

import 'widgets/home_view_swiper.dart';
import 'widgets/latest_arrival_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<ProductModel> products = [];
  late List<ProductModel> ctgsProducts;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductModelCubit>(context).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ImageAndShimmer(text: 'ShopSmart'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.22,
                    child: const HomeViewSwiper(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Latest Arrival',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.18,
                    child: BlocBuilder<ProductModelCubit, ProductModelState>(
                      builder: (context, state) {
                        products = BlocProvider.of<ProductModelCubit>(context)
                            .products;
                        return LatestArrivalListView(products: products);
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
            CategoriesGridView(catgoriesItems: catgoriesItems),
          ],
        ),
      ),
    );
  }
}
