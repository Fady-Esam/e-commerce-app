import 'package:ewsrtes/Features/admin/presentation/manager/cubits/admin_products/admin_products_cubit.dart';
import 'package:ewsrtes/Features/auth/presentation/manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:ewsrtes/Features/cart/presentation/manager/cubits/order_model_cubit/order_model_cubit.dart';
import 'package:ewsrtes/Features/profile/presentation/manager/cubits/viewed_recently_cubit/viewed_recentely_cubit.dart';
import 'package:ewsrtes/core/cubits/change_theme_cubit/change_theme_cubit.dart';
import 'package:ewsrtes/core/cubits/change_theme_cubit/change_theme_state.dart';
import 'package:ewsrtes/core/cubits/guest_cubit/guest_cubit.dart';
import 'package:ewsrtes/core/cubits/user_data_cubit/user_data_cubit.dart';
import 'package:ewsrtes/core/utils/simple_bloc_observer.dart';
import 'package:ewsrtes/core/widgets/tabs_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Features/admin/presentation/views/admin_view.dart';
import 'core/carts_and_wishlist_cubit/carts_and_wish_list_cubit.dart';
import 'core/cubits/product_model_cubit/product_model_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Ecommerce());
}

class Ecommerce extends StatelessWidget {
  const Ecommerce({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChangeThemeCubit()),
        BlocProvider(create: (context) => ProductModelCubit()),
        BlocProvider(create: (context) => CartsAndWishListCubit()),
        BlocProvider(create: (context) => ViewedRecentelyCubit()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => UserDataCubit()),
        BlocProvider(create: (context) => AdminProductsCubit()),
        BlocProvider(create: (context) => OrderModelCubit()),
        BlocProvider(create: (context) => GuestCubit()),
      ],
      child: BlocBuilder<ChangeThemeCubit, ChangeThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: BlocProvider.of<ChangeThemeCubit>(context).isDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
            ),
            home: const TabsNav(),
          );
        },
      ),
    );
  }
}
