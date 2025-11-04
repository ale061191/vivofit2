import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_session.dart';
import '../models/analytics_data.dart';

/// Servicio para gestionar el seguimiento de entrenamientos
class WorkoutTrackerService {
  static const String _storageKey = 'workout_sessions';
  final SharedPreferences _prefs;

  WorkoutTrackerService(this._prefs);

  /// Registra una nueva sesión de entrenamiento
  Future<void> logWorkout(WorkoutSession session) async {
    final sessions = await getAllSessions();
    sessions.add(session);
    await _saveSessions(sessions);
  }

  /// Obtiene todas las sesiones de entrenamiento
  Future<List<WorkoutSession>> getAllSessions() async {
    final String? sessionsJson = _prefs.getString(_storageKey);
    if (sessionsJson == null || sessionsJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = json.decode(sessionsJson);
      return decoded
          .map((json) => WorkoutSession.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al cargar sesiones: $e');
      return [];
    }
  }

  /// Obtiene sesiones filtradas por período
  Future<List<WorkoutSession>> getSessionsByPeriod(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allSessions = await getAllSessions();
    return allSessions.where((session) {
      return session.completedAt.isAfter(startDate) &&
          session.completedAt.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Obtiene sesiones de un usuario específico
  Future<List<WorkoutSession>> getUserSessions(String userId) async {
    final allSessions = await getAllSessions();
    return allSessions.where((session) => session.userId == userId).toList();
  }

  /// Obtiene sesiones de un programa específico
  Future<List<WorkoutSession>> getProgramSessions(
    String userId,
    String programId,
  ) async {
    final userSessions = await getUserSessions(userId);
    return userSessions
        .where((session) => session.programId == programId)
        .toList();
  }

  /// Obtiene sesiones de una rutina específica
  Future<List<WorkoutSession>> getRoutineSessions(
    String userId,
    String routineId,
  ) async {
    final userSessions = await getUserSessions(userId);
    return userSessions
        .where((session) => session.routineId == routineId)
        .toList();
  }

  /// Verifica si el usuario hizo ejercicio en una fecha específica
  Future<bool> hasWorkoutOnDate(String userId, DateTime date) async {
    final userSessions = await getUserSessions(userId);
    return userSessions.any((session) {
      final sessionDate = session.completedAt;
      return sessionDate.year == date.year &&
          sessionDate.month == date.month &&
          sessionDate.day == date.day;
    });
  }

  /// Calcula la racha actual de días consecutivos
  Future<int> calculateCurrentStreak(String userId) async {
    final userSessions = await getUserSessions(userId);
    if (userSessions.isEmpty) return 0;

    // Ordenar sesiones por fecha descendente
    userSessions.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    int streak = 0;
    DateTime currentDate = DateTime.now();
    final Set<String> uniqueDates = {};

    // Normalizar las fechas a solo día (sin hora)
    for (var session in userSessions) {
      final dateKey =
          '${session.completedAt.year}-${session.completedAt.month}-${session.completedAt.day}';
      uniqueDates.add(dateKey);
    }

    // Contar días consecutivos hacia atrás desde hoy
    while (true) {
      final dateKey =
          '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      if (uniqueDates.contains(dateKey)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        // Si no hay ejercicio hoy pero sí ayer, seguir contando desde ayer
        if (streak == 0) {
          currentDate = currentDate.subtract(const Duration(days: 1));
          final yesterdayKey =
              '${currentDate.year}-${currentDate.month}-${currentDate.day}';
          if (!uniqueDates.contains(yesterdayKey)) {
            break;
          }
        } else {
          break;
        }
      }
    }

    return streak;
  }

  /// Calcula la racha más larga de días consecutivos
  Future<int> calculateLongestStreak(String userId) async {
    final userSessions = await getUserSessions(userId);
    if (userSessions.isEmpty) return 0;

    // Obtener fechas únicas ordenadas
    final uniqueDates = <DateTime>{};
    for (var session in userSessions) {
      uniqueDates.add(DateTime(
        session.completedAt.year,
        session.completedAt.month,
        session.completedAt.day,
      ));
    }

    final sortedDates = uniqueDates.toList()..sort();

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final difference = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (difference == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }

  /// Genera datos analíticos para un período específico
  Future<AnalyticsData> generateAnalytics(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final sessions = await getSessionsByPeriod(startDate, endDate);
    final userSessions = sessions.where((s) => s.userId == userId).toList();

    if (userSessions.isEmpty) {
      return AnalyticsData.empty();
    }

    // Calcular métricas básicas
    final totalWorkouts = userSessions.length;
    final totalMinutes =
        userSessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
    final totalCalories =
        userSessions.fold<int>(0, (sum, s) => sum + s.caloriesBurned);

    // Calcular rachas
    final currentStreak = await calculateCurrentStreak(userId);
    final longestStreak = await calculateLongestStreak(userId);

    // Calcular promedio semanal
    final daysDifference = endDate.difference(startDate).inDays + 1;
    final weeks = daysDifference / 7.0;
    final averageWorkoutsPerWeek = weeks > 0 ? totalWorkouts / weeks : 0.0;

    // Agrupar por programa
    final Map<String, int> workoutsByProgram = {};
    for (var session in userSessions) {
      workoutsByProgram[session.programId] =
          (workoutsByProgram[session.programId] ?? 0) + 1;
    }

    // Agrupar por rutina
    final Map<String, int> workoutsByRoutine = {};
    for (var session in userSessions) {
      workoutsByRoutine[session.routineId] =
          (workoutsByRoutine[session.routineId] ?? 0) + 1;
    }

    // Generar actividades diarias
    final dailyActivities = <DailyActivity>[];
    for (var i = 0; i <= daysDifference; i++) {
      final date = startDate.add(Duration(days: i));
      final daySessions = userSessions.where((s) {
        return s.completedAt.year == date.year &&
            s.completedAt.month == date.month &&
            s.completedAt.day == date.day;
      }).toList();

      dailyActivities.add(DailyActivity(
        date: date,
        workoutsCompleted: daySessions.length,
        minutesExercised:
            daySessions.fold<int>(0, (sum, s) => sum + s.durationMinutes),
        caloriesBurned:
            daySessions.fold<int>(0, (sum, s) => sum + s.caloriesBurned),
        isRestDay: daySessions.isEmpty,
      ));
    }

    return AnalyticsData(
      totalWorkouts: totalWorkouts,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalMinutes: totalMinutes,
      totalCalories: totalCalories,
      averageWorkoutsPerWeek: averageWorkoutsPerWeek,
      workoutsByProgram: workoutsByProgram,
      workoutsByRoutine: workoutsByRoutine,
      dailyActivities: dailyActivities,
    );
  }

  /// Elimina una sesión específica
  Future<void> deleteSession(String sessionId) async {
    final sessions = await getAllSessions();
    sessions.removeWhere((session) => session.id == sessionId);
    await _saveSessions(sessions);
  }

  /// Limpia todas las sesiones (útil para testing o reset)
  Future<void> clearAllSessions() async {
    await _prefs.remove(_storageKey);
  }

  /// Guarda las sesiones en SharedPreferences
  Future<void> _saveSessions(List<WorkoutSession> sessions) async {
    final jsonList = sessions.map((s) => s.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _prefs.setString(_storageKey, jsonString);
  }

  /// Obtiene estadísticas rápidas para mostrar en cards
  Future<Map<String, dynamic>> getQuickStats(String userId) async {
    final currentStreak = await calculateCurrentStreak(userId);
    final allSessions = await getUserSessions(userId);
    final totalWorkouts = allSessions.length;
    final totalMinutes =
        allSessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);

    return {
      'currentStreak': currentStreak,
      'totalWorkouts': totalWorkouts,
      'totalMinutes': totalMinutes,
    };
  }
}
