import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pet_addoption/presentation/bloc/theme_bloc.dart';
import 'package:pet_addoption/presentation/bloc/theme_event.dart';
import 'package:pet_addoption/presentation/bloc/theme_state.dart';
import 'package:pet_addoption/core/constants/app_constants.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('ThemeBloc', () {
    late ThemeBloc themeBloc;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      themeBloc = ThemeBloc(sharedPreferences: mockSharedPreferences);
    });

    tearDown(() {
      themeBloc.close();
    });

    test('initial state is ThemeInitial', () {
      expect(themeBloc.state, equals(ThemeInitial()));
    });

    group('LoadTheme', () {
      blocTest<ThemeBloc, ThemeState>(
        'emits [ThemeLoaded] with light theme when no preference is saved',
        build: () {
          when(
            () => mockSharedPreferences.getInt(AppConstants.themeKey),
          ).thenReturn(null);
          return themeBloc;
        },
        act: (bloc) => bloc.add(const LoadTheme()),
        expect: () => [const ThemeLoaded(ThemeMode.system)],
      );

      blocTest<ThemeBloc, ThemeState>(
        'emits [ThemeLoaded] with saved theme preference',
        build: () {
          when(
            () => mockSharedPreferences.getInt(AppConstants.themeKey),
          ).thenReturn(ThemeMode.dark.index);
          return themeBloc;
        },
        act: (bloc) => bloc.add(const LoadTheme()),
        expect: () => [const ThemeLoaded(ThemeMode.dark)],
      );
    });

    group('ToggleTheme', () {
      blocTest<ThemeBloc, ThemeState>(
        'emits [ThemeLoaded] with dark theme when current is light',
        build: () {
          when(
            () => mockSharedPreferences.setInt(any(), any()),
          ).thenAnswer((_) async => true);
          return themeBloc;
        },
        seed: () => const ThemeLoaded(ThemeMode.light),
        act: (bloc) => bloc.add(const ToggleTheme()),
        expect: () => [const ThemeLoaded(ThemeMode.dark)],
        verify: (_) {
          verify(
            () => mockSharedPreferences.setInt(
              AppConstants.themeKey,
              ThemeMode.dark.index,
            ),
          ).called(1);
        },
      );

      blocTest<ThemeBloc, ThemeState>(
        'emits [ThemeLoaded] with system theme when current is dark',
        build: () {
          when(
            () => mockSharedPreferences.setInt(any(), any()),
          ).thenAnswer((_) async => true);
          return themeBloc;
        },
        seed: () => const ThemeLoaded(ThemeMode.dark),
        act: (bloc) => bloc.add(const ToggleTheme()),
        expect: () => [const ThemeLoaded(ThemeMode.system)],
        verify: (_) {
          verify(
            () => mockSharedPreferences.setInt(
              AppConstants.themeKey,
              ThemeMode.system.index,
            ),
          ).called(1);
        },
      );

      blocTest<ThemeBloc, ThemeState>(
        'emits [ThemeLoaded] with light theme when current is system',
        build: () {
          when(
            () => mockSharedPreferences.setInt(any(), any()),
          ).thenAnswer((_) async => true);
          return themeBloc;
        },
        seed: () => const ThemeLoaded(ThemeMode.system),
        act: (bloc) => bloc.add(const ToggleTheme()),
        expect: () => [const ThemeLoaded(ThemeMode.light)],
        verify: (_) {
          verify(
            () => mockSharedPreferences.setInt(
              AppConstants.themeKey,
              ThemeMode.light.index,
            ),
          ).called(1);
        },
      );
    });

    group('SetTheme', () {
      blocTest<ThemeBloc, ThemeState>(
        'emits [ThemeLoaded] with specified theme',
        build: () {
          when(
            () => mockSharedPreferences.setInt(any(), any()),
          ).thenAnswer((_) async => true);
          return themeBloc;
        },
        act: (bloc) => bloc.add(const SetTheme(ThemeMode.dark)),
        expect: () => [const ThemeLoaded(ThemeMode.dark)],
        verify: (_) {
          verify(
            () => mockSharedPreferences.setInt(
              AppConstants.themeKey,
              ThemeMode.dark.index,
            ),
          ).called(1);
        },
      );
    });
  });
}
