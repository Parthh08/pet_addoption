import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/pet_bloc.dart';
import '../bloc/pet_event.dart';
import '../bloc/pet_state.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/pet_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final ScrollController _scrollController = ScrollController();
  final ConfettiController _confettiController = ConfettiController(
    duration: AppConstants.confettiDuration,
  );
  String _lastSearchQuery = '';
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();

    context.read<PetBloc>().add(const LoadPets());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    _confettiController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text;
      if (query != _lastSearchQuery) {
        _lastSearchQuery = query;
        if (query.isEmpty) {
          context.read<PetBloc>().add(const ClearSearch());
        } else {
          context.read<PetBloc>().add(SearchPets(query: query));
        }
      }
    });
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
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
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
                  title: const Text(
                    'Pet Adoption',
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
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _onSearchChanged(),
                    decoration: InputDecoration(
                      hintText: 'Search pets by name or breed...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged();
                                },
                              )
                              : null,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              BlocConsumer<PetBloc, PetState>(
                listener: (context, state) {
                  if (state is PetAdopted) {
                    _showAdoptionConfetti(state.pet.name);
                  }

                  if (state is PetLoaded) {
                    _refreshController.refreshCompleted();
                    _refreshController.loadComplete();
                  }

                  if (state is PetError) {
                    _refreshController.refreshFailed();
                    _refreshController.loadFailed();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PetLoading && state is! PetLoaded) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is PetLoaded) {
                    if (state.pets.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pets,
                                size: 80,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.searchQuery?.isNotEmpty == true
                                    ? 'No pets found for "${state.searchQuery}"'
                                    : 'No pets available',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pull to refresh or try a different search',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final screenWidth = MediaQuery.of(context).size.width;
                    final isWideScreen = screenWidth > 800;

                    if (isWideScreen) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.1,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= state.pets.length) {
                                if (!state.hasReachedMax &&
                                    index == state.pets.length) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          context.read<PetBloc>().add(
                                            const LoadMorePets(),
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                        label: const Text('Show More'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }

                              final pet = state.pets[index];
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
                            },
                            childCount:
                                state.hasReachedMax
                                    ? state.pets.length
                                    : state.pets.length + 1,
                          ),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index == state.pets.length) {
                            if (!state.hasReachedMax) {
                              return Container(
                                padding: const EdgeInsets.all(
                                  AppConstants.defaultPadding,
                                ),
                                child: Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      context.read<PetBloc>().add(
                                        const LoadMorePets(),
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Show More Pets'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppConstants.borderRadius,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }

                          final pet = state.pets[index];
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
                        }, childCount: state.pets.length + 1),
                      );
                    }
                  }

                  if (state is PetError) {
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
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<PetBloc>().add(
                                  const LoadPets(isRefresh: true),
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
          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2,
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
