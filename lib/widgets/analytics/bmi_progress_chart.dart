import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/color_palette.dart';
import '../../models/bmi_progress.dart';

/// Gráfico circular de progreso de IMC
class BMIProgressChart extends StatelessWidget {
  final BMIProgress bmiProgress;
  final bool showDetails;

  const BMIProgressChart({
    super.key,
    required this.bmiProgress,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          showDetails ? null : 150, // Altura fija de 150 para versión compacta
      padding: EdgeInsets.all(showDetails ? 16.0 : 12.0),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            showDetails ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Text(
            'Progreso de IMC',
            style: TextStyle(
              color: ColorPalette.textPrimary,
              fontSize: showDetails ? 18 : 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: showDetails ? 20 : 6),

          // Gráfico circular
          Center(
            child: SizedBox(
              height: showDetails ? 200 : 70,
              width: showDetails ? 200 : 70,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 1,
                  centerSpaceRadius: showDetails ? 60 : 22,
                  sections: _buildPieChartSections(),
                  pieTouchData: PieTouchData(enabled: false),
                ),
              ),
            ),
          ),

          // Porcentajes fuera del gráfico (versión compacta)
          if (!showDetails) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progreso
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${bmiProgress.progressPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Pendiente
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(100 - bmiProgress.progressPercentage).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Leyenda (solo para versión detallada)
          if (showDetails) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  color: Colors.green,
                  label: 'Progreso',
                  value:
                      '${bmiProgress.progressPercentage.toStringAsFixed(1)}%',
                ),
                const SizedBox(width: 24),
                _buildLegendItem(
                  color: Colors.orange,
                  label: 'Pendiente',
                  value:
                      '${(100 - bmiProgress.progressPercentage).toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],

          if (showDetails) ...[
            const SizedBox(height: 24),
            const Divider(color: ColorPalette.textSecondary, height: 1),
            const SizedBox(height: 16),

            // Estadísticas detalladas
            _buildStatRow(
              'IMC Inicial',
              bmiProgress.initialBMI.toStringAsFixed(1),
              Icons.start,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              'IMC Actual',
              bmiProgress.currentBMI.toStringAsFixed(1),
              Icons.trending_down,
              valueColor: ColorPalette.primary,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              'IMC Objetivo',
              bmiProgress.targetBMI.toStringAsFixed(1),
              Icons.flag,
              valueColor: Colors.green,
            ),
            const SizedBox(height: 16),
            const Divider(color: ColorPalette.textSecondary, height: 1),
            const SizedBox(height: 16),

            // Calorías y peso
            _buildStatRow(
              'Calorías Quemadas',
              '${bmiProgress.totalCaloriesBurned} kcal',
              Icons.local_fire_department,
              valueColor: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              'Peso Perdido',
              '${bmiProgress.weightLost.toStringAsFixed(1)} kg',
              Icons.trending_down,
              valueColor: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              'Equivalente Quemado',
              '${bmiProgress.weightEquivalentBurned.toStringAsFixed(2)} kg',
              Icons.fitness_center,
              valueColor: ColorPalette.primary,
            ),

            if (bmiProgress.weightRemaining > 0) ...[
              const SizedBox(height: 16),
              const Divider(color: ColorPalette.textSecondary, height: 1),
              const SizedBox(height: 16),
              _buildStatRow(
                'Falta por Perder',
                '${bmiProgress.weightRemaining.toStringAsFixed(1)} kg',
                Icons.accessibility_new,
              ),
              const SizedBox(height: 8),
              Text(
                '≈ ${bmiProgress.caloriesRemainingToGoal.toStringAsFixed(0)} calorías por quemar',
                style: const TextStyle(
                  color: ColorPalette.textSecondary,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Mensaje motivacional
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bmiProgress.isHealthyWeight
                    ? Colors.green.withValues(alpha: 0.1 * 255)
                    : ColorPalette.primary.withValues(alpha: 0.1 * 255),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    bmiProgress.isHealthyWeight
                        ? Icons.check_circle
                        : Icons.trending_up,
                    color: bmiProgress.isHealthyWeight
                        ? Colors.green
                        : ColorPalette.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bmiProgress.isHealthyWeight
                          ? '¡Felicitaciones! Estás en tu peso saludable'
                          : 'Sigue así, vas por buen camino 💪',
                      style: TextStyle(
                        color: bmiProgress.isHealthyWeight
                            ? Colors.green
                            : ColorPalette.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final progress = bmiProgress.progressPercentage;
    final remaining = 100 - progress;

    return [
      // Progreso completado
      PieChartSectionData(
        color: Colors.green,
        value: progress,
        title: showDetails
            ? '${progress.toStringAsFixed(0)}%'
            : '', // Sin texto en versión compacta
        radius:
            showDetails ? 50 : 13, // Radio más pequeño para versión compacta
        titleStyle: TextStyle(
          fontSize: showDetails ? 14 : 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      // Progreso pendiente
      PieChartSectionData(
        color: Colors.orange,
        value: remaining,
        title: showDetails
            ? '${remaining.toStringAsFixed(0)}%'
            : '', // Sin texto en versión compacta
        radius:
            showDetails ? 50 : 13, // Radio más pequeño para versión compacta
        titleStyle: TextStyle(
          fontSize: showDetails ? 14 : 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: ColorPalette.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: ColorPalette.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: ColorPalette.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: ColorPalette.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? ColorPalette.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
