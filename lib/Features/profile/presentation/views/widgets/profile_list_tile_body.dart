import 'package:ewsrtes/core/cubits/change_theme_cubit/change_theme_cubit.dart';
import 'package:ewsrtes/core/cubits/change_theme_cubit/change_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../profile_wish_list_view.dart';
import '../viewed_recently_view.dart';
import 'orders_view.dart';
import 'profile_list_tile_item.dart';

class ProfileListTileBody extends StatelessWidget {
  const ProfileListTileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileListTileItem(
          image: 'users_assets/assets/images/bag/order_svg.png',
          title: 'All Orders',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrdersView(),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        ProfileListTileItem(
          image: 'users_assets/assets/images/bag/wishlist_svg.png',
          title: 'Favorites',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileWishListView(),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        ProfileListTileItem(
          image: 'users_assets/assets/images/profile/recent.png',
          title: 'Viewd recently',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewedRecentlyView(),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Divider(thickness: 2),
        const SizedBox(height: 18),
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 28),
        BlocBuilder<ChangeThemeCubit, ChangeThemeState>(
          builder: (context, state) {
            return SwitchListTile(
              secondary: Image.asset(
                'users_assets/assets/images/profile/theme.png',
              ),
              title: const Text(
                'Mode',
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
              value: BlocProvider.of<ChangeThemeCubit>(context).isDarkTheme,
              onChanged: (value) {
                BlocProvider.of<ChangeThemeCubit>(context)
                    .changeTheme(isDark: value);
              },
            );
          },
        ),
      ],
    );
  }
}
