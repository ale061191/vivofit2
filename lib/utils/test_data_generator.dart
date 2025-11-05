import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_session.dart';
import '../services/workout_tracker_service.dart';
import '../services/auth_service.dart';

/// Utilidad para generar datos de prueba para el sistema de analítica
class TestDataGenerator {
  /// Genera sesiones de ejemplo para probar la analítica
  static Future<void> generateSampleWorkouts(BuildContext context) async {
    final trackerService = context.read<WorkoutTrackerService>();
    final authService = context.read<AuthService>();
    final userId = authService.currentUser?.id ?? 'demo_user';

    final now = DateTime.now();
    const uuid = Uuid();

    // Patrón de entrenamiento más realista:
    // - Última semana: más consistente (5-6 días)
    // - Semana anterior: medianamente consistente (4 días)
    // - Semanas más antiguas: menos consistente (2-3 días por semana)

    int totalWorkouts = 0;

    // Últimos 7 días - Usuario comprometido (racha actual)
    for (int i = 0; i < 7; i++) {
      if (i == 2) continue; // Solo 1 día de descanso
      final date = now.subtract(Duration(days: i));
      final routineId = _getRandomRoutineId(i + totalWorkouts);
      final duration = _getRandomDuration(i);

      final session = WorkoutSession(
        id: uuid.v4(),
        userId: userId,
        programId: 'program_${(totalWorkouts % 3) + 1}',
        routineId: routineId,
        completedAt: date.subtract(Duration(hours: _getRandomHour())),
        durationMinutes: duration,
        caloriesBurned: _estimateCalories(duration),
        notes: _getRandomNote(routineId),
      );

      await trackerService.logWorkout(session);
      totalWorkouts++;
    }

    // Días 8-14 (semana pasada) - Moderadamente activo
    for (int i = 7; i < 14; i++) {
      if (i % 2 == 0) continue; // Varios días de descanso
      final date = now.subtract(Duration(days: i));
      final routineId = _getRandomRoutineId(i + totalWorkouts);
      final duration = _getRandomDuration(i);

      final session = WorkoutSession(
        id: uuid.v4(),
        userId: userId,
        programId: 'program_${(totalWorkouts % 3) + 1}',
        routineId: routineId,
        completedAt: date.subtract(Duration(hours: _getRandomHour())),
        durationMinutes: duration,
        caloriesBurned: _estimateCalories(duration),
        notes: _getRandomNote(routineId),
      );

      await trackerService.logWorkout(session);
      totalWorkouts++;
    }

    // Días 15-30 (semanas anteriores) - Irregular
    for (int i = 14; i < 30; i++) {
      if (i % 3 != 0) continue; // Muchos días de descanso
      final date = now.subtract(Duration(days: i));
      final routineId = _getRandomRoutineId(i + totalWorkouts);
      final duration = _getRandomDuration(i);

      final session = WorkoutSession(
        id: uuid.v4(),
        userId: userId,
        programId: 'program_${(totalWorkouts % 3) + 1}',
        routineId: routineId,
        completedAt: date.subtract(Duration(hours: _getRandomHour())),
        durationMinutes: duration,
        caloriesBurned: _estimateCalories(duration),
        notes: _getRandomNote(routineId),
      );

      await trackerService.logWorkout(session);
      totalWorkouts++;
    }
  }

  static int _getRandomDuration(int seed) {
    final durations = [30, 35, 40, 45, 50, 60];
    return durations[seed % durations.length];
  }

  static int _getRandomHour() {
    final hours = [6, 7, 8, 17, 18, 19, 20]; // Mañana o tarde
    return hours[DateTime.now().millisecond % hours.length];
  }

  static int _estimateCalories(int minutes) {
    // Estimación más variada: 4-6 calorías por minuto
    final caloriesPerMin = 4.5 + (DateTime.now().millisecond % 3) * 0.5;
    return (minutes * caloriesPerMin).round();
  }

  static String _getRandomNote(String routineId) {
    final notes = {
      'routine_1': [
        '¡Excelente sesión de pecho!',
        'Aumenté peso en press',
        'Buen pump',
        'Me sentí fuerte'
      ],
      'routine_2': [
        'Gran trabajo de espalda',
        'Dominadas mejoradas',
        'Remo pesado',
        'Buena conexión'
      ],
      'routine_3': [
        'Piernas ardiendo 🔥',
        'Sentadillas profundas',
        'Día de pierna épico',
        'Cansado pero satisfecho'
      ],
      'routine_4': [
        'Brazos bombeados',
        'Buen volumen de brazos',
        'Bíceps y tríceps trabajados',
        'Excelente sesión'
      ],
    };

    final routineNotes = notes[routineId] ?? ['Buen entrenamiento'];
    return routineNotes[DateTime.now().millisecond % routineNotes.length];
  }

  static String _getRandomRoutineId(int seed) {
    final routines = ['routine_1', 'routine_2', 'routine_3', 'routine_4'];
    return routines[seed % routines.length];
  }

  /// Muestra un diálogo para confirmar la generación de datos de prueba
  static void showGenerateDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Row(
          children: [
            Icon(Icons.auto_graph, color: Color(0xFFFF9900), size: 28),
            SizedBox(width: 12),
            Text(
              'Generar Datos de Prueba',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Se generarán 30 días de entrenamientos simulados con el siguiente patrón:',
              style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFFFF9900), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Última semana: muy activo (racha)',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFFFF9900), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Semana pasada: moderado',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFFFF9900), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Semanas anteriores: irregular',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Esto te permitirá ver gráficos y estadísticas realistas.',
              style: TextStyle(
                color: Color(0xFFFF9900),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFFB0B0B0)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Guardar el contexto antes de cualquier operación asíncrona
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              navigator.pop(); // Cerrar diálogo de confirmación

              // Mostrar indicador de carga
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF9900),
                  ),
                ),
              );

              try {
                await generateSampleWorkouts(context);

                // Cerrar loading
                navigator.pop();

                // Mostrar mensaje de éxito
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '¡30 días de datos generados! Los gráficos se actualizarán',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    duration: const Duration(seconds: 4),
                  ),
                );
              } catch (e) {
                // Cerrar loading en caso de error
                navigator.pop();

                // Mostrar mensaje de error
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Error al generar datos: $e',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9900),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Generar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
