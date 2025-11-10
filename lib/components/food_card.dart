import 'package:flutter/material.dart';
import 'package:vivofit/models/food.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/theme/app_theme.dart';

/// Card visual para mostrar un alimento
class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback? onTap;
  const FoodCard({super.key, required this.food, this.onTap});

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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                bottomLeft: Radius.circular(AppTheme.radiusMedium),
              ),
              child: food.imageUrl != null
                  ? Image.asset(
                      food.imageUrl!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 80,
                        width: 80,
                        color: ColorPalette.background,
                        child: const Center(
                          child: Icon(Icons.image,
                              size: 32, color: ColorPalette.primary),
                        ),
                      ),
                    )
                  : Container(
                      height: 80,
                      width: 80,
                      color: ColorPalette.background,
                      child: const Center(
                        child: Icon(Icons.image,
                            size: 32, color: ColorPalette.primary),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: ColorPalette.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text('${food.calories} cal',
                        style: const TextStyle(color: ColorPalette.primary)),
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
