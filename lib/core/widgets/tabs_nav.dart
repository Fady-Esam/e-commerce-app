import 'package:ewsrtes/Features/cart/presentation/views/cart_view.dart';
import 'package:ewsrtes/Features/profile/presentation/views/profile_view.dart';
import 'package:ewsrtes/Features/search/presentation/views/search_view.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import 'package:ewsrtes/core/carts_and_wishlist_cubit/carts_and_wish_list_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../Features/cart/presentation/manager/cubits/order_model_cubit/order_model_cubit.dart';
import '../../Features/home/presentation/views/home_view.dart';
import '../../Features/profile/presentation/manager/cubits/viewed_recently_cubit/viewed_recentely_cubit.dart';
import '../cubits/guest_cubit/guest_cubit.dart';

class TabsNav extends StatefulWidget {
  const TabsNav({super.key});

  @override
  State<TabsNav> createState() => _TabsNavState();
}

class _TabsNavState extends State<TabsNav> {
  int currentViewIndex = 0;
  late PageController pageController;
  List<Widget> views = const [
    HomeView(),
    SearchView(),
    CartView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentViewIndex);
    if (FirebaseAuth.instance.currentUser != null) {
      BlocProvider.of<GuestCubit>(context).setIsGuest(isGuest: false);
      BlocProvider.of<CartsAndWishListCubit>(context).fetchCarts();
      BlocProvider.of<CartsAndWishListCubit>(context).fetchWishList();
      BlocProvider.of<OrderModelCubit>(context)
          .fetchOrders(userId: FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        BlocProvider.of<ViewedRecentelyCubit>(context).viewedRecentlyProducts =
            [];
      });
    } else {
      BlocProvider.of<GuestCubit>(context).setIsGuest(isGuest: true);
      setState(() {
        BlocProvider.of<CartsAndWishListCubit>(context).carts = [];
        BlocProvider.of<CartsAndWishListCubit>(context).wishListProducts = [];
        BlocProvider.of<OrderModelCubit>(context).ordersList = [];
        BlocProvider.of<ViewedRecentelyCubit>(context).viewedRecentlyProducts =
            [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: views,
        onPageChanged: (int index) {
          setState(() {
            currentViewIndex = index;
          });
        },
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 3,
        onDestinationSelected: (index) {
          currentViewIndex = index;
          setState(() {});
          pageController.jumpToPage(currentViewIndex);
        },
        selectedIndex: currentViewIndex,
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: 'Home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: 'Search',
          ),
          BlocBuilder<CartsAndWishListCubit, CartsAndWishListState>(
            builder: (context, state) {
              int length =
                  BlocProvider.of<CartsAndWishListCubit>(context).carts.length;
              return NavigationDestination(
                selectedIcon: const Icon(IconlyBold.bag2),
                icon: !BlocProvider.of<GuestCubit>(context).isUserGuest
                    ? Badge(
                        label: Text(length.toString()),
                        child: const Icon(IconlyLight.bag2),
                      )
                    : const Icon(IconlyLight.bag2),
                label: 'Cart',
              );
            },
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
