import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/core/theme/theme_cubit.dart';
import 'package:graduation_project/features/Cart/data/repo/cart_repo.dart';
import 'package:graduation_project/features/Cart/logic/cart_cubit/cart_cubit.dart';
import 'package:graduation_project/features/HomePage/data/repo/Favorite/favorite_repo.dart';
import 'package:graduation_project/features/login_signup/login/logic/login/login_cubit.dart';
import 'package:graduation_project/features/splash/presentation/view/splash_view.dart';
import 'package:graduation_project/core/bloc_observer.dart';
import 'package:graduation_project/core/di/service_locator.dart';
import 'package:graduation_project/features/HomePage/logic/Favorite_Cubit/favorite_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  setupServiceLocator();
  final isLoggedIn = await LoginCubit.isLoggedIn();

  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider(
          create: (_) => FavoriteCubit(getIt<FavoriteRepository>())..getFavorites(),
        ),
        BlocProvider(create: (_) => CartCubit(getIt<CartRepository>())),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          // Remove scroll glow on web/desktop
          scrollBehavior: _AppScrollBehavior(),
          home: const SplashView(),
        );
      },
    );
  }
}

/// Removes the overscroll glow effect that looks bad on web/desktop.
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}
