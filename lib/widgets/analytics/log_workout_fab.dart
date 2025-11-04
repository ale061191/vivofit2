import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../theme/color_palette.dart';
import '../../services/workout_tracker_service.dart';
import '../../services/auth_service.dart';
import '../../models/workout_session.dart';

/// Botón flotante para registrar entrenamientos completados
class LogWorkoutFAB extends StatelessWidget {
  final String programId;
  final String routineId;
  final VoidCallback? onWorkoutLogged;

  const LogWorkoutFAB({
    super.key,
    required this.programId,
    required this.routineId,
    this.onWorkoutLogged,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showLogWorkoutDialog(context),
      backgroundColor: ColorPalette.primary,
      child: const Icon(
        Icons.check_circle,
        color: ColorPalette.textPrimary,
        size: 28,
      ),
    );
  }

  void _showLogWorkoutDialog(BuildContext context) {
    final durationController = TextEditingController(text: '30');
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorPalette.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: const Text(
          '¡Entrenamiento Completado!',
          style: TextStyle(
            color: ColorPalette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Duración (minutos)',
              style: TextStyle(
                color: ColorPalette.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: ColorPalette.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorPalette.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: '30',
                hintStyle: const TextStyle(color: ColorPalette.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Notas (opcional)',
              style: TextStyle(
                color: ColorPalette.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              style: const TextStyle(color: ColorPalette.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorPalette.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: '¿Cómo te sentiste?',
                hintStyle: const TextStyle(color: ColorPalette.textSecondary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: ColorPalette.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final duration = int.tryParse(durationController.text) ?? 30;
              await _logWorkout(context, duration, notesController.text);
              if (context.mounted) {
                Navigator.pop(context);
                _showSuccessSnackbar(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Guardar',
              style: TextStyle(
                color: ColorPalette.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logWorkout(
    BuildContext context,
    int duration,
    String notes,
  ) async {
    final authService = context.read<AuthService>();
    final userId = authService.currentUser?.id ?? '';
    final trackerService = context.read<WorkoutTrackerService>();

    // Estimación simple de calorías: ~5 cal/min para entrenamiento moderado
    final estimatedCalories = (duration * 5).toInt();

    final session = WorkoutSession(
      id: const Uuid().v4(),
      userId: userId,
      programId: programId,
      routineId: routineId,
      completedAt: DateTime.now(),
      durationMinutes: duration,
      caloriesBurned: estimatedCalories,
      notes: notes,
    );

    await trackerService.logWorkout(session);

    // Callback para refrescar UI padre
    onWorkoutLogged?.call();
  }

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              '¡Entrenamiento registrado!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
