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

  /// Crear desde respuesta de Supabase
  factory AnalyticsData.fromSupabaseResponse(Map<String, dynamic> data) {
    final dailyActivitiesList = (data['dailyActivities'] as List<dynamic>?)
        ?.map((activity) => DailyActivity(
              date: activity['date'] as DateTime,
              workoutsCompleted: activity['workoutsCompleted'] as int,
              minutesExercised: 0, // No se calcula en el servicio aún
              caloriesBurned: activity['caloriesBurned'] as int,
            ))
        .toList() ??
        [];

    return AnalyticsData(
      totalWorkouts: data['totalWorkouts'] as int,
      currentStreak: data['currentStreak'] as int,
      longestStreak: data['longestStreak'] as int,
      totalMinutes: data['totalMinutes'] as int,
      totalCalories: data['totalCalories'] as int,
      averageWorkoutsPerWeek: (data['averageWorkoutsPerWeek'] as num).toDouble(),
      workoutsByProgram: Map<String, int>.from(data['workoutsByProgram'] as Map),
      workoutsByRoutine: Map<String, int>.from(data['workoutsByRoutine'] as Map),
      dailyActivities: dailyActivitiesList,
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
