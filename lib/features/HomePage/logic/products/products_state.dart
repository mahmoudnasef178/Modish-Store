import 'package:modish_store/features/HomePage/data/models/products/products_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<ProductModel> products;
  final int totalCount;
  ProductSuccess({required this.products, required this.totalCount});
}

class ProductFailure extends ProductState {
  final String errorMessage;
  ProductFailure(this.errorMessage);
}
