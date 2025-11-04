import 'package:flutter/material.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/theme/app_theme.dart';

/// Card personalizado para programas de entrenamiento
class ProgramCard extends StatelessWidget {
  final String name;
  final int durationWeeks;
  final double rating;
  final int totalReviews;
  final String? imageUrl;
  final bool isPopular;
  final VoidCallback onTap;

  const ProgramCard({
    super.key,
    required this.name,
    required this.durationWeeks,
    required this.rating,
    required this.totalReviews,
    this.imageUrl,
    this.isPopular = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        decoration: BoxDecoration(
          gradient: ColorPalette.cardGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del programa
              Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorPalette.cardBackgroundLight,
                      image: imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imageUrl == null
                        ? const Center(
                            child: Icon(
                              Icons.fitness_center,
                              size: 48,
                              color: ColorPalette.textTertiary,
                            ),
                          )
                        : null,
                  ),
                  if (isPopular)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'POPULAR',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Información del programa
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: ColorPalette.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '$durationWeeks semanas',
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorPalette.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: ColorPalette.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorPalette.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' ($totalReviews)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: ColorPalette.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card personalizado para rutinas de ejercicio
class RoutineCard extends StatelessWidget {
  final String name;
  final String muscleGroup;
  final int durationMinutes;
  final int calories;
  final String? imageUrl;
  final bool isLocked;
  final VoidCallback onTap;

  const RoutineCard({
    super.key,
    required this.name,
    required this.muscleGroup,
    required this.durationMinutes,
    required this.calories,
    this.imageUrl,
    this.isLocked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: ColorPalette.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen/thumbnail
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: ColorPalette.cardBackgroundLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusMedium),
                  bottomLeft: Radius.circular(AppTheme.radiusMedium),
                ),
              ),
              child: Stack(
                children: [
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.radiusMedium),
                        bottomLeft: Radius.circular(AppTheme.radiusMedium),
                      ),
                      child: Image.network(
                        imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 40,
                        color: ColorPalette.primary,
                      ),
                    ),
                  if (isLocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.radiusMedium),
                          bottomLeft: Radius.circular(AppTheme.radiusMedium),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock,
                          color: ColorPalette.primary,
                          size: 32,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Información
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorPalette.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      muscleGroup,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorPalette.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: ColorPalette.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '$durationMinutes min',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorPalette.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: ColorPalette.primary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '$calories kcal',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorPalette.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card personalizado para alimentos
class FoodCard extends StatelessWidget {
  final String name;
  final String category;
  final int preparationTime;
  final int calories;
  final String? imageUrl;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.name,
    required this.category,
    required this.preparationTime,
    required this.calories,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: ColorPalette.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: ColorPalette.cardBackgroundLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusMedium),
                  bottomLeft: Radius.circular(AppTheme.radiusMedium),
                ),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.radiusMedium),
                        bottomLeft: Radius.circular(AppTheme.radiusMedium),
                      ),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.restaurant,
                        color: ColorPalette.primary,
                        size: 32,
                      ),
                    ),
            ),
            // Información
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorPalette.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorPalette.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: ColorPalette.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '$preparationTime min',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorPalette.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: ColorPalette.primary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '$calories kcal',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorPalette.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card personalizado para artículos de blog
class ArticleCard extends StatelessWidget {
  final String title;
  final String author;
  final String topic;
  final int readTime;
  final String? imageUrl;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.title,
    required this.author,
    required this.topic,
    required this.readTime,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: ColorPalette.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusMedium),
                  topRight: Radius.circular(AppTheme.radiusMedium),
                ),
                child: Image.network(
                  imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            // Información
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      topic.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: ColorPalette.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: ColorPalette.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          author,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ColorPalette.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: ColorPalette.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$readTime min',
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColorPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
