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
