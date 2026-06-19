import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/core/theme/app_theme.dart';
import 'package:modish_store/core/theme/theme_cubit.dart';
import 'package:modish_store/features/Cart/data/repo/cart_repo.dart';
import 'package:modish_store/features/Cart/logic/cart_cubit/cart_cubit.dart';
import 'package:modish_store/features/HomePage/data/repo/Favorite/favorite_repo.dart';
import 'package:modish_store/features/login_signup/login/logic/login/login_cubit.dart';
import 'package:modish_store/features/splash/presentation/view/splash_view.dart';
import 'package:modish_store/core/bloc_observer.dart';
import 'package:modish_store/core/di/service_locator.dart';
import 'package:modish_store/features/HomePage/logic/Favorite_Cubit/favorite_cubit.dart';

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
          builder: (context, child) {
            final double width = MediaQuery.of(context).size.width;
            if (width > 600) {
              final originalData = MediaQuery.of(context);
              final customData = originalData.copyWith(
                size: Size(480, originalData.size.height - 48), // Adjusting height for 24px vertical margin
              );
              return Container(
                color: isDark ? const Color(0xff0a0a0c) : const Color(0xfff3f4f6),
                child: Center(
                  child: Container(
                    width: 480,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: MediaQuery(
                      data: customData,
                      child: Material(
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            }
            return child!;
          },
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
