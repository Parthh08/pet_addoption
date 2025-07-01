import 'package:go_router/go_router.dart';
import 'package:pet_addoption/presentation/pages/detail_page.dart';
import 'package:pet_addoption/presentation/pages/favorites_page.dart';
import 'package:pet_addoption/presentation/pages/history_page.dart';
import 'package:pet_addoption/presentation/pages/home_page.dart';
import 'package:pet_addoption/presentation/pages/main_page.dart';

import '../../domain/entities/pet.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            builder: (context, state) => const FavoritesPage(),
          ),
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const HistoryPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/pet/:id',
        name: 'detail',
        builder: (context, state) {
          final pet = state.extra as Pet;
          return DetailPage(pet: pet);
        },
      ),
    ],
  );
}
