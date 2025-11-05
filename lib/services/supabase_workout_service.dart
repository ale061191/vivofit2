import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivofit/config/supabase_config.dart';
import 'package:vivofit/models/workout_session.dart';

/// Servicio de gestión de entrenamientos con Supabase
/// Registra sesiones de workout y calcula estadísticas
class SupabaseWorkoutService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Registrar nueva sesión de entrenamiento
  Future<bool> logWorkoutSession({
    required String programId,
    required String routineId,
    required int durationMinutes,
    required int caloriesBurned,
    List<String> exercisesCompleted = const [],
    String? notes,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      await _supabase.from(SupabaseConfig.workoutSessionsTable).insert({
        'user_id': userId,
        'program_id': programId,
        'routine_id': routineId,
        'duration_minutes': durationMinutes,
        'calories_burned': caloriesBurned,
        'exercises_completed': exercisesCompleted.length,
        'notes': notes ?? '',
        'completed_at': DateTime.now().toIso8601String(),
      });

      // Actualizar total de calorías en el historial de IMC más reciente
      await _updateTotalCalories(caloriesBurned);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error al registrar sesión de entrenamiento: $e');
      return false;
    }
  }

  /// Obtener sesiones de entrenamiento por rango de fechas
  Future<List<WorkoutSession>> getWorkoutSessions({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      var queryBuilder = _supabase
          .from(SupabaseConfig.workoutSessionsTable)
          .select()
          .eq('user_id', userId);

      if (startDate != null) {
        queryBuilder =
            queryBuilder.gte('completed_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        queryBuilder =
            queryBuilder.lte('completed_at', endDate.toIso8601String());
      }

      var orderedQuery = queryBuilder.order('completed_at', ascending: false);

      final response =
          await (limit != null ? orderedQuery.limit(limit) : orderedQuery);

      return response
          .map<WorkoutSession>((data) => _workoutSessionFromSupabase(data))
          .toList();
    } catch (e) {
      debugPrint('Error al obtener sesiones de entrenamiento: $e');
      return [];
    }
  }

  /// Obtener estadísticas de entrenamientos
  Future<Map<String, dynamic>> getWorkoutStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return {
          'totalSessions': 0,
          'totalMinutes': 0,
          'totalCalories': 0,
          'averageCaloriesPerSession': 0.0,
        };
      }

      var queryBuilder = _supabase
          .from(SupabaseConfig.workoutSessionsTable)
          .select()
          .eq('user_id', userId);

      if (startDate != null) {
        queryBuilder =
            queryBuilder.gte('completed_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        queryBuilder =
            queryBuilder.lte('completed_at', endDate.toIso8601String());
      }

      final response = await queryBuilder;

      if (response.isEmpty) {
        return {
          'totalSessions': 0,
          'totalMinutes': 0,
          'totalCalories': 0,
          'averageCaloriesPerSession': 0.0,
        };
      }

      int totalSessions = response.length;
      int totalMinutes = 0;
      int totalCalories = 0;

      for (var session in response) {
        totalMinutes += (session['duration_minutes'] as int?) ?? 0;
        totalCalories += (session['calories_burned'] as int?) ?? 0;
      }

      return {
        'totalSessions': totalSessions,
        'totalMinutes': totalMinutes,
        'totalCalories': totalCalories,
        'averageCaloriesPerSession':
            totalSessions > 0 ? totalCalories / totalSessions : 0.0,
      };
    } catch (e) {
      debugPrint('Error al obtener estadísticas de entrenamientos: $e');
      return {
        'totalSessions': 0,
        'totalMinutes': 0,
        'totalCalories': 0,
        'averageCaloriesPerSession': 0.0,
      };
    }
  }

  /// Obtener sesiones agrupadas por fecha
  Future<Map<DateTime, List<WorkoutSession>>> getWorkoutsByDate({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final sessions = await getWorkoutSessions(
        startDate: startDate,
        endDate: endDate,
      );

      final Map<DateTime, List<WorkoutSession>> groupedSessions = {};

      for (var session in sessions) {
        final date = DateTime(
          session.completedAt.year,
          session.completedAt.month,
          session.completedAt.day,
        );

        if (!groupedSessions.containsKey(date)) {
          groupedSessions[date] = [];
        }

        groupedSessions[date]!.add(session);
      }

      return groupedSessions;
    } catch (e) {
      debugPrint('Error al agrupar sesiones por fecha: $e');
      return {};
    }
  }

  /// Actualizar total de calorías en el historial de IMC
  Future<void> _updateTotalCalories(int caloriesBurned) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Obtener el registro más reciente de IMC
      final bmiHistory = await _supabase
          .from(SupabaseConfig.bmiHistoryTable)
          .select()
          .eq('user_id', userId)
          .order('recorded_at', ascending: false)
          .limit(1);

      if (bmiHistory.isEmpty) return;

      final latestBMI = bmiHistory.first;
      final currentTotal = (latestBMI['total_calories_burned'] as int?) ?? 0;

      await _supabase
          .from(SupabaseConfig.bmiHistoryTable)
          .update({'total_calories_burned': currentTotal + caloriesBurned}).eq(
              'id', latestBMI['id']);
    } catch (e) {
      debugPrint('Error al actualizar total de calorías: $e');
    }
  }

  /// Obtener todas las sesiones de entrenamiento del usuario
  Future<List<WorkoutSession>> getAllSessions() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from(SupabaseConfig.workoutSessionsTable)
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      return response
          .map<WorkoutSession>((data) => _workoutSessionFromSupabase(data))
          .toList();
    } catch (e) {
      debugPrint('Error al obtener todas las sesiones: $e');
      return [];
    }
  }

  /// Obtener total de calorías quemadas del usuario
  Future<double> getTotalCaloriesBurned(String userId) async {
    try {
      final stats = await getWorkoutStats();
      return stats['totalCalories'].toDouble();
    } catch (e) {
      debugPrint('Error al obtener total de calorías: $e');
      return 0.0;
    }
  }

  /// Obtener estadísticas rápidas para el HomeScreen
  Future<Map<String, dynamic>> getQuickStats(String userId) async {
    try {
      final allSessions = await getAllSessions();
      final totalWorkouts = allSessions.length;
      final totalMinutes = allSessions.fold<int>(
        0,
        (sum, s) => sum + s.durationMinutes,
      );
      final totalCalories = allSessions.fold<int>(
        0,
        (sum, s) => sum + s.caloriesBurned,
      );

      // Calcular racha actual
      final streaks = _calculateStreaks(allSessions);
      final currentStreak = streaks['current'] ?? 0;

      return {
        'currentStreak': currentStreak,
        'totalWorkouts': totalWorkouts,
        'totalMinutes': totalMinutes,
        'totalCalories': totalCalories,
      };
    } catch (e) {
      debugPrint('Error al obtener quick stats: $e');
      return {
        'currentStreak': 0,
        'totalWorkouts': 0,
        'totalMinutes': 0,
        'totalCalories': 0,
      };
    }
  }

  /// Generar analítica para un rango de fechas
  Future<Map<String, dynamic>> generateAnalytics(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final sessions = await getWorkoutSessions(
        startDate: startDate,
        endDate: endDate,
      );

      final stats = await getWorkoutStats(
        startDate: startDate,
        endDate: endDate,
      );

      // Calcular rachas
      final allSessions = await getAllSessions();
      final streaks = _calculateStreaks(allSessions);

      // Calcular actividad diaria
      final dailyActivities = _calculateDailyActivities(sessions, startDate, endDate);

      // Agrupar por rutina
      final workoutsByRoutine = <String, int>{};
      for (var session in sessions) {
        workoutsByRoutine[session.routineId] = 
            (workoutsByRoutine[session.routineId] ?? 0) + 1;
      }

      // Calcular promedio de entrenamientos por semana
      final daysDiff = endDate.difference(startDate).inDays + 1;
      final weeks = daysDiff / 7.0;
      final avgPerWeek = weeks > 0 ? stats['totalSessions'] / weeks : 0.0;

      return {
        'totalWorkouts': stats['totalSessions'],
        'totalMinutes': stats['totalMinutes'],
        'totalCalories': stats['totalCalories'],
        'currentStreak': streaks['current'],
        'longestStreak': streaks['longest'],
        'averageWorkoutsPerWeek': avgPerWeek,
        'dailyActivities': dailyActivities,
        'workoutsByRoutine': workoutsByRoutine,
        'workoutsByProgram': <String, int>{}, // Puede expandirse en el futuro
      };
    } catch (e) {
      debugPrint('Error al generar analítica: $e');
      return {
        'totalWorkouts': 0,
        'totalMinutes': 0,
        'totalCalories': 0,
        'currentStreak': 0,
        'longestStreak': 0,
        'averageWorkoutsPerWeek': 0.0,
        'dailyActivities': [],
        'workoutsByRoutine': {},
        'workoutsByProgram': {},
      };
    }
  }

  /// Calcular rachas de entrenamiento
  Map<String, int> _calculateStreaks(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) {
      return {'current': 0, 'longest': 0};
    }

    // Ordenar por fecha descendente
    final sortedSessions = List<WorkoutSession>.from(sessions)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    // Obtener días únicos con entrenamientos
    final workoutDays = sortedSessions
        .map((s) => DateTime(s.completedAt.year, s.completedAt.month, s.completedAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    for (int i = 0; i < workoutDays.length; i++) {
      if (i == 0) {
        // Verificar si la racha actual está activa
        final daysDiff = todayDate.difference(workoutDays[i]).inDays;
        if (daysDiff <= 1) {
          currentStreak = 1;
          tempStreak = 1;
        }
      } else {
        final daysDiff = workoutDays[i - 1].difference(workoutDays[i]).inDays;
        if (daysDiff == 1) {
          tempStreak++;
          if (currentStreak > 0) currentStreak++;
        } else {
          if (tempStreak > longestStreak) longestStreak = tempStreak;
          tempStreak = 1;
          if (currentStreak > 0) currentStreak = 0; // Racha rota
        }
      }
    }

    if (tempStreak > longestStreak) longestStreak = tempStreak;
    if (currentStreak > longestStreak) longestStreak = currentStreak;

    return {'current': currentStreak, 'longest': longestStreak};
  }

  /// Calcular actividad diaria
  List<Map<String, dynamic>> _calculateDailyActivities(
    List<WorkoutSession> sessions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final activities = <Map<String, dynamic>>[];
    final daysDiff = endDate.difference(startDate).inDays + 1;

    // Agrupar sesiones por fecha
    final sessionsByDate = <DateTime, List<WorkoutSession>>{};
    for (var session in sessions) {
      final date = DateTime(
        session.completedAt.year,
        session.completedAt.month,
        session.completedAt.day,
      );
      sessionsByDate[date] = [...(sessionsByDate[date] ?? []), session];
    }

    // Crear entrada para cada día del período
    for (int i = 0; i < daysDiff; i++) {
      final date = startDate.add(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final daySessions = sessionsByDate[dateKey] ?? [];

      activities.add({
        'date': dateKey,
        'workoutsCompleted': daySessions.length,
        'caloriesBurned': daySessions.fold<int>(
          0,
          (sum, session) => sum + session.caloriesBurned,
        ),
      });
    }

    return activities;
  }

  /// Convertir datos de Supabase a modelo WorkoutSession
  WorkoutSession _workoutSessionFromSupabase(Map<String, dynamic> data) {
    return WorkoutSession(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      programId: data['program_id'] as String,
      routineId: data['routine_id'] as String,
      completedAt: DateTime.parse(data['completed_at'] as String),
      durationMinutes: data['duration_minutes'] as int,
      caloriesBurned: data['calories_burned'] as int,
      exercisesCompleted: [], // Se almacena como número en DB
      notes: data['notes'] as String? ?? '',
    );
  }
}
