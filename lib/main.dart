import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/service_locator.dart';
import 'presentation/bloc/pet_bloc.dart';
import 'presentation/bloc/favorites_bloc.dart';
import 'presentation/bloc/history_bloc.dart';
import 'presentation/bloc/theme_bloc.dart';
import 'presentation/bloc/theme_event.dart';
import 'presentation/bloc/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Hive.initFlutter();
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PetBloc>()),
        BlocProvider(create: (_) => sl<FavoritesBloc>()),
        BlocProvider(create: (_) => sl<HistoryBloc>()),
        BlocProvider(create: (_) => sl<ThemeBloc>()..add(const LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          ThemeMode themeMode = ThemeMode.system;
          if (state is ThemeLoaded) {
            themeMode = state.themeMode;
          }

          return MaterialApp.router(
            title: 'Pet Adoption',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
