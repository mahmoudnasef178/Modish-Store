import 'package:graduation_project/features/HomePage/data/models/Favorite/favorite_model.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final List<FavoriteItemModel> items;
  FavoriteSuccess(this.items);
}

class FavoriteFailure extends FavoriteState {
  final String errorMessage;
  FavoriteFailure(this.errorMessage);
}
