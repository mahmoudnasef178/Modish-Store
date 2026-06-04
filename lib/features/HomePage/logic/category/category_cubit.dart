import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/HomePage/data/repo/category/category_repo.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(CategoryInitial());

  Future<void> getCategories() async {
    if (isClosed) return;
    emit(CategoryLoading());
    try {
      final categories = await _repository.getCategories();
      if (isClosed) return;
      emit(CategorySuccess(categories));
    } catch (e) {
      if (isClosed) return;
      emit(CategoryFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
