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
    final uuid = const Uuid();

    // Limpiar datos previos (opcional)
    // await trackerService.clearAllSessions();

    // Generar entrenamientos de los últimos 30 días
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));

      // No todos los días tienen entrenamiento (70% de probabilidad)
      if (i % 3 == 0) continue; // Días de descanso

      // 1-2 entrenamientos por día activo
      final workoutsToday = (i % 5 == 0) ? 2 : 1;

      for (int j = 0; j < workoutsToday; j++) {
        final routineId = _getRandomRoutineId(i);
        final duration = 30 + (i % 3) * 15; // 30, 45 o 60 minutos
        final session = WorkoutSession(
          id: uuid.v4(),
          userId: userId,
          programId: 'program_${(i % 3) + 1}',
          routineId: routineId,
          completedAt: date.subtract(Duration(hours: j * 2)),
          durationMinutes: duration,
          caloriesBurned: duration * 5,
          notes: 'Sesión de prueba',
        );

        await trackerService.logWorkout(session);
      }
    }
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
        title: const Text('Generar Datos de Prueba'),
        content: const Text(
          '¿Deseas generar datos de ejemplo para probar el sistema de analítica?\n\n'
          'Esto creará 30 días de entrenamientos simulados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await generateSampleWorkouts(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Datos de prueba generados exitosamente!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Generar'),
          ),
        ],
      ),
    );
  }
}
