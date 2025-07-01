import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';
import '../bloc/pet_bloc.dart';
import '../bloc/pet_event.dart';
import '../bloc/pet_state.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/pet_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ConfettiController _confettiController = ConfettiController(
    duration: AppConstants.confettiDuration,
  );

  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(const LoadFavorites());
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showAdoptionConfetti(String petName) {
    _confettiController.play();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'You\'ve now adopted $petName! 🎉',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PetBloc, PetState>(
      listener: (context, state) {
        if (state is PetAdopted) {
          _showAdoptionConfetti(state.pet.name);
          context.read<FavoritesBloc>().add(const RefreshFavorites());
        }
        if (state is FavoriteToggled) {
          context.read<FavoritesBloc>().add(const RefreshFavorites());
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  expandedHeight: 120,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.favorite,
                            AppColors.favorite.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    title: const Text(
                      'My Favorites',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  actions: [
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, state) {
                        IconData themeIcon = Icons.brightness_auto;
                        if (state is ThemeLoaded) {
                          switch (state.themeMode) {
                            case ThemeMode.light:
                              themeIcon = Icons.light_mode;
                              break;
                            case ThemeMode.dark:
                              themeIcon = Icons.dark_mode;
                              break;
                            case ThemeMode.system:
                              themeIcon = Icons.brightness_auto;
                              break;
                          }
                        }

                        return IconButton(
                          icon: Icon(themeIcon, color: Colors.white),
                          onPressed: () {
                            context.read<ThemeBloc>().add(const ToggleTheme());
                          },
                          tooltip: 'Toggle Theme',
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        context.read<FavoritesBloc>().add(
                          const RefreshFavorites(),
                        );
                      },
                      tooltip: 'Refresh Favorites',
                    ),
                  ],
                ),
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is FavoritesLoaded) {
                      if (state.favorites.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 80,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No favorites yet',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add pets to your favorites by tapping the heart icon',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.go('/');
                                  },
                                  icon: const Icon(Icons.explore),
                                  label: const Text('Explore Pets'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final screenWidth = MediaQuery.of(context).size.width;
                      final isWideScreen = screenWidth > 800;

                      if (isWideScreen) {
                        // Web: Use SliverGrid with 2 columns
                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio:
                                      1.1, 
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final pet = state.favorites[index];
                              return PetCard(
                                pet: pet,
                                onFavoriteTap: () {
                                  context.read<PetBloc>().add(
                                    ToggleFavoritePet(pet),
                                  );
                                },
                                onAdoptTap:
                                    pet.isAdopted
                                        ? null
                                        : () {
                                          context.read<PetBloc>().add(
                                            AdoptPet(pet),
                                          );
                                        },
                              );
                            }, childCount: state.favorites.length),
                          ),
                        );
                      } else {
                      
                        return SliverPadding(
                          padding: const EdgeInsets.only(bottom: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final pet = state.favorites[index];
                              return PetCard(
                                pet: pet,
                                onFavoriteTap: () {
                                  context.read<PetBloc>().add(
                                    ToggleFavoritePet(pet),
                                  );
                                },
                                onAdoptTap:
                                    pet.isAdopted
                                        ? null
                                        : () {
                                          context.read<PetBloc>().add(
                                            AdoptPet(pet),
                                          );
                                        },
                              );
                            }, childCount: state.favorites.length),
                          ),
                        );
                      }
                    }

                    if (state is FavoritesError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 80,
                                color: AppColors.error.withOpacity(0.6),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Oops! Something went wrong',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<FavoritesBloc>().add(
                                    const RefreshFavorites(),
                                  );
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // Downward
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 5,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.success,
                Colors.orange,
                Colors.pink,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
