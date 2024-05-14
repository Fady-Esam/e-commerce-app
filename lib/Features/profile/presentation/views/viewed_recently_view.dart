import 'package:ewsrtes/Features/profile/presentation/manager/cubits/viewed_recently_cubit/viewed_recentely_cubit.dart';
import 'package:ewsrtes/core/models/product_model.dart';
import 'package:ewsrtes/core/widgets/image_and_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/viewed_recently_grid_view.dart';

class ViewedRecentlyView extends StatelessWidget {
  const ViewedRecentlyView({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProductModel> viewedRecentlyList =
        BlocProvider.of<ViewedRecentelyCubit>(context).viewedRecentlyProducts;
    return Scaffold(
      appBar: AppBar(
        title: const ImageAndShimmer(text: 'Viewd Recently'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 22),
            Expanded(
              child: ViewedRecentlyGridView(
                  viewedRecentlyList: viewedRecentlyList),
            ),
          ],
        ),
      ),
    );
  }
}
