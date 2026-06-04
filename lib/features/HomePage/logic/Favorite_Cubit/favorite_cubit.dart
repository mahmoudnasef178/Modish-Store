import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/HomePage/data/models/Favorite/favorite_model.dart';
import 'package:graduation_project/features/HomePage/data/models/products/products_model.dart';
import 'package:graduation_project/features/HomePage/data/repo/Favorite/favorite_repo.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repository;

  FavoriteCubit(this._repository) : super(FavoriteInitial());

  List<FavoriteItemModel> _items = [];

  Future<void> getFavorites() async {
    emit(FavoriteLoading());
    try {
      final response = await _repository.getFavorites();
      _items = response.favoriteItems; // ✅ اتغير من items لـ favoriteItems
      emit(FavoriteSuccess(List.from(_items)));
    } catch (e) {
      emit(FavoriteFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final exists = isFavorite(product.productId);
    print('TOGGLE FAVORITE - exists: $exists, productId: ${product.productId}');
    print('CURRENT ITEMS: ${_items.map((e) => e.id).toList()}');
    try {
      if (exists) {
        await _repository.removeFromFavorite(product.productId);
        _items.removeWhere((e) => e.id == product.productId);
      } else {
        await _repository.addToFavorite(product.productId);
        _items.add(
          FavoriteItemModel(
            id: product.productId,
            productName: product.name,
            pictureUrl: product.pictureUrl,
            price: product.price,
            category: product.categoryName,
          ),
        );
      }
      print('AFTER TOGGLE ITEMS: ${_items.map((e) => e.id).toList()}');
      emit(FavoriteSuccess(List.from(_items)));
    } catch (e) {
      print('TOGGLE FAVORITE ERROR: $e');
      emit(FavoriteFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> toggleFavoriteById(String productId) async {
    try {
      await _repository.removeFromFavorite(productId);
      _items.removeWhere((e) => e.id == productId);
      emit(FavoriteSuccess(List.from(_items)));
    } catch (e) {
      emit(FavoriteFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  bool isFavorite(String productId) => _items.any((e) => e.id == productId);
}
