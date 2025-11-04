import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../theme/color_palette.dart';
import '../../services/workout_tracker_service.dart';
import '../../services/auth_service.dart';

/// Tarjeta de progreso destacada para el Home
class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final userId = authService.currentUser?.id ?? '';

    return FutureBuilder<Map<String, dynamic>>(
      future: context.read<WorkoutTrackerService>().getQuickStats(userId),
      builder: (context, snapshot) {
        final stats = snapshot.data ??
            {
              'currentStreak': 0,
              'totalWorkouts': 0,
              'totalMinutes': 0,
            };

        return Container(
          margin: const EdgeInsets.only(bottom: 24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorPalette.primary,
                ColorPalette.primary.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push('/analytics'),
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.analytics_outlined,
                          color: ColorPalette.textPrimary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Mi Progreso',
                            style: TextStyle(
                              color: ColorPalette.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: ColorPalette.textPrimary.withOpacity(0.7),
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatItem(
                          icon: Icons.local_fire_department,
                          value: '${stats['currentStreak']}',
                          label: 'Racha (días)',
                        ),
                        const SizedBox(width: 24),
                        _buildStatItem(
                          icon: Icons.fitness_center,
                          value: '${stats['totalWorkouts']}',
                          label: 'Entrenamientos',
                        ),
                        const SizedBox(width: 24),
                        _buildStatItem(
                          icon: Icons.timer_outlined,
                          value: '${stats['totalMinutes']}',
                          label: 'Minutos',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Toca para ver estadísticas detalladas',
                      style: TextStyle(
                        color: ColorPalette.textPrimary.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: ColorPalette.textPrimary,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  color: ColorPalette.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: ColorPalette.textPrimary.withOpacity(0.9),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
