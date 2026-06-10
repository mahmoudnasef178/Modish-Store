import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/features/Cart/data/repo/cart_repo.dart';
import 'package:graduation_project/features/Cart/data/repo/order_repo.dart';
import 'package:graduation_project/features/HomePage/data/repo/Favorite/favorite_repo.dart';
import 'package:graduation_project/features/HomePage/data/repo/products/products_repo.dart';
import 'package:graduation_project/features/login_signup/login/data/repo/login_repo.dart';
import 'package:graduation_project/features/login_signup/signup/data/repo/signUp_repo.dart';
import 'package:graduation_project/features/profile/data/repo/profile_repo.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // ─── Dio client singleton ──────────────────────────────────────────
  getIt.registerLazySingleton<Dio>(() => Dio());

  // ─── Repositories singletons ───────────────────────────────────────
  getIt.registerLazySingleton<CartRepository>(() => CartRepository(getIt<Dio>()));
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepository(getIt<Dio>()));
  getIt.registerLazySingleton<FavoriteRepository>(() => FavoriteRepository(getIt<Dio>()));
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepository(getIt<Dio>()));
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepository(getIt<Dio>()));
  getIt.registerLazySingleton<SignupRepository>(() => SignupRepository(getIt<Dio>()));
}
