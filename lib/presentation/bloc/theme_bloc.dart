import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeBloc({required this.sharedPreferences}) : super(ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);
  }

  void _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) {
    final themeIndex = sharedPreferences.getInt(AppConstants.themeKey) ?? 0;
    final themeMode = ThemeMode.values[themeIndex];
    emit(ThemeLoaded(themeMode));
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    if (state is ThemeLoaded) {
      final currentTheme = (state as ThemeLoaded).themeMode;
      ThemeMode newTheme;

      switch (currentTheme) {
        case ThemeMode.light:
          newTheme = ThemeMode.dark;
          break;
        case ThemeMode.dark:
          newTheme = ThemeMode.system;
          break;
        case ThemeMode.system:
          newTheme = ThemeMode.light;
          break;
      }

      _saveTheme(newTheme);
      emit(ThemeLoaded(newTheme));
    }
  }

  void _onSetTheme(SetTheme event, Emitter<ThemeState> emit) {
    _saveTheme(event.themeMode);
    emit(ThemeLoaded(event.themeMode));
  }

  void _saveTheme(ThemeMode themeMode) {
    sharedPreferences.setInt(AppConstants.themeKey, themeMode.index);
  }
}
