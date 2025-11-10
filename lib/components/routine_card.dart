import 'package:flutter/material.dart';
import 'package:vivofit/models/routine.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/theme/app_theme.dart';

/// Card visual para mostrar una rutina
class RoutineCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback? onTap;
  const RoutineCard({super.key, required this.routine, this.onTap});

  String _getMuscleLabel(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'chest':
        return 'Pecho';
      case 'back':
        return 'Espalda';
      case 'legs':
        return 'Piernas';
      case 'arms':
        return 'Brazos';
      default:
        return muscle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: ColorPalette.cardBackground,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.radiusMedium),
                    bottomLeft: Radius.circular(AppTheme.radiusMedium),
                  ),
                  child: routine.thumbnailUrl != null
                      ? Image.asset(
                          routine.thumbnailUrl!,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 90,
                            width: 90,
                            color: ColorPalette.background,
                            child: const Center(
                              child: Icon(Icons.image,
                                  size: 32, color: ColorPalette.primary),
                            ),
                          ),
                        )
                      : Container(
                          height: 90,
                          width: 90,
                          color: ColorPalette.background,
                          child: const Center(
                            child: Icon(Icons.image,
                                size: 32, color: ColorPalette.primary),
                          ),
                        ),
                ),
                if (routine.isPremium)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.lock,
                          color: ColorPalette.primary, size: 22),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      routine.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getMuscleLabel(routine.muscleGroup),
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorPalette.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer,
                            color: ColorPalette.textSecondary, size: 16),
                        const SizedBox(width: 4),
                        Text('${routine.durationMinutes} min',
                            style: const TextStyle(
                                color: ColorPalette.textSecondary,
                                fontSize: 13)),
                        const SizedBox(width: 12),
                        Icon(Icons.local_fire_department,
                            color: ColorPalette.primary, size: 16),
                        const SizedBox(width: 4),
                        Text('${routine.estimatedCalories} kcal',
                            style: const TextStyle(
                                color: ColorPalette.primary, fontSize: 13)),
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
