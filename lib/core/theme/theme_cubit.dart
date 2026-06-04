import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    emit(prefs.getBool('isDark') ?? false);
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !state;
    await prefs.setBool('isDark', newValue);
    emit(newValue);
  }
}
