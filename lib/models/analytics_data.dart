/// Modelo para datos analíticos procesados
class AnalyticsData {
  final int totalWorkouts;
  final int currentStreak;
  final int longestStreak;
  final int totalMinutes;
  final int totalCalories;
  final double averageWorkoutsPerWeek;
  final Map<String, int> workoutsByProgram;
  final Map<String, int> workoutsByRoutine;
  final List<DailyActivity> dailyActivities;

  AnalyticsData({
    required this.totalWorkouts,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalMinutes,
    required this.totalCalories,
    required this.averageWorkoutsPerWeek,
    required this.workoutsByProgram,
    required this.workoutsByRoutine,
    required this.dailyActivities,
  });

  /// Datos vacíos por defecto
  factory AnalyticsData.empty() {
    return AnalyticsData(
      totalWorkouts: 0,
      currentStreak: 0,
      longestStreak: 0,
      totalMinutes: 0,
      totalCalories: 0,
      averageWorkoutsPerWeek: 0.0,
      workoutsByProgram: {},
      workoutsByRoutine: {},
      dailyActivities: [],
    );
  }
}

/// Representa la actividad de un día específico
class DailyActivity {
  final DateTime date;
  final int workoutsCompleted;
  final int minutesExercised;
  final int caloriesBurned;
  final bool isRestDay;

  DailyActivity({
    required this.date,
    required this.workoutsCompleted,
    required this.minutesExercised,
    required this.caloriesBurned,
    this.isRestDay = false,
  });

  /// Verifica si el día tuvo actividad
  bool get hasActivity => workoutsCompleted > 0;
}

/// Enumeración para períodos de filtro
enum AnalyticsPeriod {
  day('Día'),
  week('Semana'),
  month('Mes');

  final String label;
  const AnalyticsPeriod(this.label);
}
