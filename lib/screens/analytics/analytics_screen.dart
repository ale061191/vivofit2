import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/color_palette.dart';
import '../../services/supabase_workout_service.dart';
import '../../services/supabase_auth_service.dart';
import '../../services/supabase_user_service.dart';
import '../../models/analytics_data.dart';
import '../../models/bmi_progress.dart';
import '../../utils/test_data_generator.dart';
import '../../widgets/analytics/bmi_progress_chart.dart';

/// Pantalla principal de analítica y estadísticas
/// Migrada a Supabase - Noviembre 2025
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsPeriod _selectedPeriod = AnalyticsPeriod.week;
  AnalyticsData? _analyticsData;
  BMIProgress? _bmiProgress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAndGenerateTestData();
  }

  Future<void> _checkAndGenerateTestData() async {
    final workoutService = context.read<SupabaseWorkoutService>();
    final sessions = await workoutService.getAllSessions();

    // Si no hay datos, generar automáticamente
    if (sessions.isEmpty) {
      await TestDataGenerator.generateSampleWorkouts(context);
    }

    // Cargar analítica después de verificar/generar datos
    await _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    final authService = context.read<SupabaseAuthService>();
    final userId = authService.currentUser?.id ?? '';
    final workoutService = context.read<SupabaseWorkoutService>();
    final userService = context.read<SupabaseUserService>();

    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case AnalyticsPeriod.day:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case AnalyticsPeriod.week:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case AnalyticsPeriod.month:
        startDate = DateTime(now.year, now.month, 1);
        break;
    }

    // Obtener analítica desde Supabase
    final analyticsResponse = await workoutService.generateAnalytics(
      userId,
      startDate,
      now,
    );

    final analytics = AnalyticsData.fromSupabaseResponse(analyticsResponse);

    // Calcular progreso de IMC
    BMIProgress? bmiProgress;
    final user = await userService.getUserProfile(userId);
    if (user != null && user.height != null && user.weight != null) {
      final totalCalories = await workoutService.getTotalCaloriesBurned(userId);
      final currentBMI = user.imc ?? 0;

      // Calcular peso inicial basado en calorías quemadas
      final weightEquivalentBurned = totalCalories / 7700; // 7700 kcal ≈ 1 kg
      final initialWeight = user.weight! + weightEquivalentBurned;
      final heightInMeters = user.height! / 100;
      final initialBMI = initialWeight / (heightInMeters * heightInMeters);

      bmiProgress = BMIProgress.initial(
        currentBMI: currentBMI,
        currentWeight: user.weight!,
        height: user.height!,
      ).copyWith(
        initialBMI: initialBMI,
        initialWeight: initialWeight,
        totalCaloriesBurned: totalCalories,
        lastUpdateDate: DateTime.now(),
      );
    }

    setState(() {
      _analyticsData = analytics;
      _bmiProgress = bmiProgress;
      _isLoading = false;
    });
  }

  Future<void> _generateTestData() async {
    await TestDataGenerator.generateSampleWorkouts(context);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '¡30 días de datos generados! Los gráficos se actualizarán.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
      // Recargar analítica después de generar datos
      await _loadAnalytics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        backgroundColor: ColorPalette.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorPalette.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Análisis de Rendimiento',
          style: TextStyle(
            color: ColorPalette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_chart,
              color: ColorPalette.primary,
            ),
            onPressed: () => _generateTestData(),
            tooltip: 'Generar datos de prueba',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorPalette.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 24),
                  _buildStatsCards(),
                  const SizedBox(height: 24),
                  if (_bmiProgress != null) ...[
                    BMIProgressChart(bmiProgress: _bmiProgress!),
                    const SizedBox(height: 24),
                  ],
                  _buildActivityChart(),
                  const SizedBox(height: 24),
                  _buildWorkoutDistribution(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: AnalyticsPeriod.values.map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedPeriod = period);
                _loadAnalytics();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: isSelected ? ColorPalette.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  period.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? ColorPalette.textPrimary
                        : ColorPalette.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsCards() {
    if (_analyticsData == null) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.local_fire_department,
                value: '${_analyticsData!.currentStreak}',
                label: 'Racha Actual',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_events,
                value: '${_analyticsData!.longestStreak}',
                label: 'Mejor Racha',
                color: Colors.yellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.fitness_center,
                value: '${_analyticsData!.totalWorkouts}',
                label: 'Entrenamientos',
                color: ColorPalette.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.timer_outlined,
                value: '${_analyticsData!.totalMinutes}m',
                label: 'Tiempo Total',
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.local_fire_department_outlined,
                value: '${_analyticsData!.totalCalories}',
                label: 'Calorías',
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.trending_up,
                value:
                    _analyticsData!.averageWorkoutsPerWeek.toStringAsFixed(1),
                label: 'Promedio/Semana',
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: ColorPalette.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColorPalette.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    if (_analyticsData == null || _analyticsData!.dailyActivities.isEmpty) {
      return _buildEmptyState('No hay datos de actividad para este período');
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividad Diaria',
            style: TextStyle(
              color: ColorPalette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: ColorPalette.textSecondary.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >=
                            _analyticsData!.dailyActivities.length) {
                          return const SizedBox.shrink();
                        }
                        final date =
                            _analyticsData!.dailyActivities[value.toInt()].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(
                              color: ColorPalette.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: ColorPalette.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (_analyticsData!.dailyActivities.length - 1).toDouble(),
                minY: 0,
                maxY: _getMaxWorkouts() + 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: _analyticsData!.dailyActivities
                        .asMap()
                        .entries
                        .map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.workoutsCompleted.toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: ColorPalette.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: ColorPalette.primary,
                          strokeWidth: 2,
                          strokeColor: ColorPalette.background,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: ColorPalette.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Entrenamientos por día',
            style: TextStyle(
              color: ColorPalette.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutDistribution() {
    if (_analyticsData == null ||
        (_analyticsData!.workoutsByProgram.isEmpty &&
            _analyticsData!.workoutsByRoutine.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribución de Entrenamientos',
            style: TextStyle(
              color: ColorPalette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_analyticsData!.workoutsByRoutine.isNotEmpty) ...[
            const Text(
              'Por Rutina',
              style: TextStyle(
                color: ColorPalette.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ..._analyticsData!.workoutsByRoutine.entries.map((entry) {
              final total = _analyticsData!.totalWorkouts;
              final percentage = (entry.value / total * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getRoutineName(entry.key),
                          style: const TextStyle(
                            color: ColorPalette.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$percentage% (${entry.value})',
                          style: const TextStyle(
                            color: ColorPalette.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: entry.value / total,
                        backgroundColor:
                            ColorPalette.textSecondary.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          ColorPalette.primary,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 64,
              color: ColorPalette.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ColorPalette.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxWorkouts() {
    if (_analyticsData == null || _analyticsData!.dailyActivities.isEmpty) {
      return 5.0;
    }
    final max = _analyticsData!.dailyActivities
        .map((d) => d.workoutsCompleted)
        .reduce((a, b) => a > b ? a : b);
    return max.toDouble();
  }

  String _getRoutineName(String routineId) {
    // Aquí puedes mapear IDs a nombres legibles
    // Por ahora retornamos el ID
    final names = {
      'routine_1': 'Pecho',
      'routine_2': 'Espalda',
      'routine_3': 'Piernas',
      'routine_4': 'Brazos',
    };
    return names[routineId] ?? 'Rutina';
  }
}
