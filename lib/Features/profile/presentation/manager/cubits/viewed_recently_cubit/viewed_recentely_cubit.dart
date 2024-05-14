import 'package:ewsrtes/core/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'viewed_recentely_state.dart';

class ViewedRecentelyCubit extends Cubit<ViewedRecentelyState> {
  ViewedRecentelyCubit() : super(ViewedRecentelyInitial());
  List<ProductModel> viewedRecentlyProducts = [];
  void addToViewedRecentely({required ProductModel producMOdel}) {
    viewedRecentlyProducts.add(producMOdel);
  }

  bool isViewedRecently({required ProductModel producMOdel}) {
    for (int i = 0; i < viewedRecentlyProducts.length; i++) {
      if (viewedRecentlyProducts[i].productId == producMOdel.productId) {
        return true;
      }
    }
    return false;
  }
}
