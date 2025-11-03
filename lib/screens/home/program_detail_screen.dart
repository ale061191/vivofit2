import 'package:flutter/material.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/models/program.dart';
import 'package:vivofit/models/routine.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/navigation/app_routes.dart';

/// Pantalla de Detalle de Programa
/// Muestra información completa del programa, beneficios, rutinas incluidas y opción de compra
class ProgramDetailScreen extends StatelessWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    // Buscar el programa por ID
    final program = Program.mockList().firstWhere(
      (p) => p.id == programId,
      orElse: () => Program.mockList().first,
    );

    // Obtener rutinas del programa
    final programRoutines = Routine.mockList()
        .where((r) => program.routineIds.contains(r.id))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con imagen
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (program.imageUrl != null)
                    Image.network(
                      program.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: ColorPalette.cardBackgroundLight,
                      child: const Icon(
                        Icons.fitness_center,
                        size: 100,
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
                  // Popular badge
                  if (program.isPopular)
                    Positioned(
                      top: 60,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'POPULAR',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
                  // Título y rating
                  Text(
                    program.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: ColorPalette.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        program.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      Text(
                        ' (${program.totalReviews} reseñas)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Información rápida
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoChip(
                        Icons.calendar_today,
                        '${program.durationWeeks} semanas',
                      ),
                      _buildInfoChip(
                        Icons.trending_up,
                        program.levelTranslated,
                      ),
                      _buildInfoChip(
                        Icons.person,
                        program.trainer,
                      ),
                    ],
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
                    program.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: ColorPalette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Beneficios
                  const Text(
                    'Beneficios',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...program.benefits.map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: ColorPalette.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              benefit,
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

                  // Rutinas incluidas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rutinas Incluidas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      Text(
                        '${programRoutines.length} rutinas',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...programRoutines.take(3).map(
                        (routine) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => AppRoutes.goToRoutineDetail(
                                context, routine.id),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ColorPalette.cardBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: ColorPalette.cardBackgroundLight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: ColorPalette.primary
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.play_circle_outline,
                                      color: ColorPalette.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          routine.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: ColorPalette.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${routine.durationMinutes} min • ${routine.muscleGroup}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: ColorPalette.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: ColorPalette.textTertiary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  if (programRoutines.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Center(
                        child: Text(
                          '+${programRoutines.length - 3} rutinas más',
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorPalette.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),

      // Botón de compra flotante
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorPalette.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Precio',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorPalette.textTertiary,
                    ),
                  ),
                  Text(
                    '\$${program.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Comprar Programa',
                  onPressed: () {
                    AppRoutes.goToPayment(context, program.id);
                  },
                  icon: Icons.shopping_cart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPalette.cardBackgroundLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: ColorPalette.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: ColorPalette.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
