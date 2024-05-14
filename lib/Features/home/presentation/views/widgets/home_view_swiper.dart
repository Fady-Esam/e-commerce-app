
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../../../data/images_list.dart';

class HomeViewSwiper extends StatelessWidget {
  const HomeViewSwiper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Image.asset(
          images[index],
          fit: BoxFit.fill,
        );
      },
      itemCount: 2,
      autoplay: true,
      duration: 1,
      pagination: const SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          activeColor: Colors.red,
          color: Colors.white,
        ),
      ),
    );
  }
}