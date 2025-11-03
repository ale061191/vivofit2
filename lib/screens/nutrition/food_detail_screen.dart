import 'package:flutter/material.dart';
import 'package:vivofit/models/food.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';

/// Pantalla de Detalle de Alimento
/// Muestra información nutricional completa, ingredientes y pasos de preparación
class FoodDetailScreen extends StatelessWidget {
  final String foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context) {
    // Buscar el alimento por ID
    final food = Food.mockList().firstWhere(
      (f) => f.id == foodId,
      orElse: () => Food.mockList().first,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con imagen
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                food.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (food.imageUrl != null)
                    Image.network(
                      food.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: ColorPalette.cardBackgroundLight,
                      child: const Icon(
                        Icons.restaurant,
                        size: 80,
                        color: ColorPalette.textTertiary,
                      ),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          ColorPalette.background.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información rápida
                  Row(
                    children: [
                      _buildQuickInfo(
                        Icons.timer_outlined,
                        '${food.preparationTimeMinutes} min',
                      ),
                      const SizedBox(width: 16),
                      _buildQuickInfo(
                        Icons.restaurant_menu,
                        '${food.servings} porción${food.servings > 1 ? "es" : ""}',
                      ),
                      const SizedBox(width: 16),
                      _buildQuickInfo(
                        Icons.trending_up,
                        food.difficultyTranslated,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      food.categoryTranslated,
                      style: const TextStyle(
                        color: ColorPalette.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Información nutricional
                  const Text(
                    'Información Nutricional',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: ColorPalette.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildNutritionRow(
                          'Calorías',
                          '${food.calories}',
                          'kcal',
                          Icons.local_fire_department,
                        ),
                        const Divider(color: ColorPalette.cardBackgroundLight),
                        _buildNutritionRow(
                          'Proteínas',
                          food.protein.toStringAsFixed(1),
                          'g',
                          Icons.fitness_center,
                        ),
                        const Divider(color: ColorPalette.cardBackgroundLight),
                        _buildNutritionRow(
                          'Carbohidratos',
                          food.carbs.toStringAsFixed(1),
                          'g',
                          Icons.grain,
                        ),
                        const Divider(color: ColorPalette.cardBackgroundLight),
                        _buildNutritionRow(
                          'Grasas',
                          food.fats.toStringAsFixed(1),
                          'g',
                          Icons.water_drop,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Descripción
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    food.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: ColorPalette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredientes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ingredientes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      Text(
                        '${food.ingredients.length} items',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...food.ingredients.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: ColorPalette.primary
                                      .withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorPalette.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: ColorPalette.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 24),

                  // Pasos de preparación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Preparación',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      Text(
                        '${food.preparationSteps.length} pasos',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...food.preparationSteps.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  gradient: ColorPalette.primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: ColorPalette.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 24),

                  // Tags
                  if (food.tags.isNotEmpty) ...[
                    const Text(
                      'Etiquetas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: food.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ColorPalette.cardBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ColorPalette.cardBackgroundLight,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ColorPalette.textSecondary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: ColorPalette.primary, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: ColorPalette.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionRow(
    String label,
    String value,
    String unit,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: ColorPalette.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: ColorPalette.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorPalette.primary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 14,
              color: ColorPalette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
