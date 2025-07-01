import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/pet.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAdoptTap;

  const PetCard({
    super.key,
    required this.pet,
    this.onFavoriteTap,
    this.onAdoptTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isInGrid = constraints.maxWidth < 300;

        return Card(
          margin: EdgeInsets.symmetric(
            horizontal: isInGrid ? 4 : AppConstants.defaultPadding,
            vertical: isInGrid ? 4 : 8,
          ),
          child: InkWell(
            onTap: () {
              context.push('/pet/${pet.id}', extra: pet);
            },
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'pet-${pet.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppConstants.borderRadius),
                        ),
                        child: AspectRatio(
                          aspectRatio: isInGrid ? 18 / 9 : 16 / 9,
                          child: CachedNetworkImage(
                            imageUrl: pet.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.pets,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        radius: 20,
                        child: IconButton(
                          icon: Icon(
                            pet.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                pet.isFavorite
                                    ? AppColors.favorite
                                    : Colors.grey,
                            size: 20,
                          ),
                          onPressed: onFavoriteTap,
                        ),
                      ),
                    ),
                    if (pet.isAdopted)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.adopted,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'ADOPTED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(
                    isInGrid ? 8.0 : AppConstants.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              pet.name,
                              style: (isInGrid
                                      ? Theme.of(context).textTheme.titleMedium
                                      : Theme.of(
                                        context,
                                      ).textTheme.headlineSmall)
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        pet.isAdopted
                                            ? AppColors.adopted
                                            : null,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${pet.price.toStringAsFixed(0)}',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isInGrid ? 2 : 4),
                      Text(
                        pet.breed,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: pet.isAdopted ? AppColors.adopted : null,
                        ),
                      ),
                      SizedBox(height: isInGrid ? 4 : 8),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.cake_outlined,
                            label:
                                '${pet.age} ${pet.age == 1 ? 'year' : 'years'}',
                            isAdopted: pet.isAdopted,
                          ),
                          const SizedBox(width: 8),
                          _InfoChip(
                            icon:
                                pet.gender == 'Male'
                                    ? Icons.male
                                    : Icons.female,
                            label: pet.gender,
                            isAdopted: pet.isAdopted,
                          ),
                          const SizedBox(width: 8),
                          _InfoChip(
                            icon: Icons.straighten,
                            label: pet.size,
                            isAdopted: pet.isAdopted,
                          ),
                        ],
                      ),
                      if (!pet.isAdopted) ...[
                        SizedBox(height: isInGrid ? 6 : 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: onAdoptTap,
                            icon: const Icon(Icons.pets),
                            label: const Text('Adopt Me'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAdopted;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.isAdopted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isAdopted
                ? AppColors.adopted.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isAdopted ? AppColors.adopted : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isAdopted ? AppColors.adopted : AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
