import 'package:ewsrtes/core/cubits/product_model_cubit/product_model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/change_theme_cubit/change_theme_cubit.dart';
import 'widgets/admin_item.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  bool isLightTheme = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductModelCubit>(context).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> adminItems = {
      'admin_assets/assets/images/dashboard/cloud.png': 'Add a new Product',
      'admin_assets/assets/images/shopping_cart.png': 'Inspect all Products',
      'admin_assets/assets/images/dashboard/order.png': 'View orders',
    };
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'admin_assets/assets/images/shopping_cart.png',
              height: 55,
            ),
            const SizedBox(width: 18),
            const Text(
              'Admin',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                isLightTheme = !isLightTheme;
                setState(() {});
                BlocProvider.of<ChangeThemeCubit>(context)
                    .changeTheme(isDark: isLightTheme);
              },
              icon: Icon(
                BlocProvider.of<ChangeThemeCubit>(context).isDarkTheme
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.only(top: 14),
        itemCount: 3,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return AdminItem(
            text: adminItems.values.toList()[index],
            image: adminItems.keys.toList()[index],
          );
        },
      ),
    );
  }
}
