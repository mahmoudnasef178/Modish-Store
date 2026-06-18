import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modish_store/features/HomePage/data/repo/products/products_repo.dart';
import 'package:modish_store/features/HomePage/logic/products/products_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(ProductInitial());

  Future<void> getProducts({String? categoryId, String? search}) async {
    if (isClosed) return;
    emit(ProductLoading());
    try {
      final response = await _repository.getProducts(
        categoryId: categoryId,
        search: search,
      );
      if (isClosed) return;
      emit(
        ProductSuccess(
          products: response.data,
          totalCount: response.data.length,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(ProductFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> getRecommended() async {
    if (isClosed) return;
    emit(ProductLoading());
    try {
      final products = await _repository.getRecommended();
      if (isClosed) return;
      emit(ProductSuccess(products: products, totalCount: products.length));
    } catch (e) {
      if (isClosed) return;
      emit(ProductFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
