import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/features/HomePage/data/models/Favorite/favorite_model.dart';
import 'package:modish_store/features/HomePage/data/models/products/products_model.dart';
import 'package:modish_store/features/HomePage/data/repo/Favorite/favorite_repo.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repository;

  FavoriteCubit(this._repository) : super(FavoriteInitial());

  List<FavoriteItemModel> _items = [];

  Future<void> getFavorites() async {
    emit(FavoriteLoading());
    try {
      final response = await _repository.getFavorites();
      _items = response.favoriteItems;
      emit(FavoriteSuccess(List.from(_items)));
    } catch (e) {
      emit(FavoriteFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final exists = isFavorite(product.productId);
    debugPrint('TOGGLE FAVORITE - exists: $exists, productId: ${product.productId}');
    debugPrint('CURRENT ITEMS: ${_items.map((e) => e.id).toList()}');
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
      debugPrint('AFTER TOGGLE ITEMS: ${_items.map((e) => e.id).toList()}');
      emit(FavoriteSuccess(List.from(_items)));
    } catch (e) {
      debugPrint('TOGGLE FAVORITE ERROR: $e');
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
