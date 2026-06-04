import 'package:graduation_project/features/HomePage/data/models/category/category_model.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<CategoryModel> categories;
  CategorySuccess(this.categories);
}

class CategoryFailure extends CategoryState {
  final String errorMessage;
  CategoryFailure(this.errorMessage);
}
