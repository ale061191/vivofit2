import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:vivofit/models/routine.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';

/// Pantalla de Detalle de Rutina
/// Muestra ejercicios, video demostrativo y detalles completos
class RoutineDetailScreen extends StatefulWidget {
  final String routineId;

  const RoutineDetailScreen({super.key, required this.routineId});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  bool _hasVideo = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final routine = _getRoutine();

    if (routine.videoUrl != null && routine.videoUrl!.isNotEmpty) {
      _hasVideo = true;
      try {
        // En producción, usar la URL real del video
        // Por ahora, mostramos un placeholder ya que las URLs son de ejemplo
        setState(() {
          _isVideoInitialized = false; // Video no disponible en mock
        });
      } catch (e) {
        debugPrint('Error al inicializar video: $e');
      }
    }
  }

  Routine _getRoutine() {
    return Routine.mockList().firstWhere(
      (r) => r.id == widget.routineId,
      orElse: () => Routine.mockList().first,
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routine = _getRoutine();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                routine.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (routine.thumbnailUrl != null)
                    Image.network(
                      routine.thumbnailUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: ColorPalette.cardBackgroundLight,
                      child: const Icon(
                        Icons.fitness_center,
                        size: 80,
                        color: ColorPalette.textTertiary,
                      ),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          ColorPalette.background.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información rápida
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.timer,
                        '${routine.durationMinutes} min',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.local_fire_department,
                        '${routine.estimatedCalories} kcal',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.trending_up,
                        routine.difficultyTranslated,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          routine.muscleGroupTranslated,
                          style: const TextStyle(
                            color: ColorPalette.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (routine.isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: ColorPalette.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium,
                                size: 12,
                                color: Colors.black,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Premium',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Video player (si está disponible)
                  if (_hasVideo) ...[
                    const Text(
                      'Video Tutorial',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: ColorPalette.cardGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _isVideoInitialized && _chewieController != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Chewie(controller: _chewieController!),
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_circle_outline,
                                    size: 64,
                                    color: ColorPalette.primary,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Video no disponible en demo',
                                    style: TextStyle(
                                      color: ColorPalette.textTertiary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Descripción
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    routine.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: ColorPalette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lista de ejercicios
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ejercicios',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      Text(
                        '${routine.exercises.length} ejercicios',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...routine.exercises.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: ColorPalette.cardGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  gradient: ColorPalette.primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                entry.value.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorPalette.textPrimary,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    '${entry.value.sets} series x ${entry.value.reps} reps',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: ColorPalette.textSecondary,
                                    ),
                                  ),
                                  if (entry.value.restSeconds != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Descanso: ${entry.value.restSeconds}s',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: ColorPalette.textTertiary,
                                      ),
                                    ),
                                  ],
                                  if (entry.value.notes != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.value.notes!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: ColorPalette.primary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              trailing: const Icon(
                                Icons.fitness_center,
                                color: ColorPalette.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: ColorPalette.cardGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ColorPalette.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: ColorPalette.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
