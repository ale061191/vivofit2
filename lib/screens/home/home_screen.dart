import 'package:flutter/material.dart';
import 'package:vivofit/components/custom_cards.dart';
import 'package:vivofit/components/common_widgets.dart';
import 'package:vivofit/models/program.dart';
import 'package:vivofit/models/routine.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';

/// Pantalla Home
/// Muestra programas y rutinas de ejercicio
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Program> _programs = Program.mockList();
  final List<Routine> _routines = Routine.mockList();
  String _selectedMuscleGroup = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vivofit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Funcionalidad de notificaciones pendiente de integración con backend
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Actualizar datos desde el servidor
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Programas destacados
              SectionHeader(
                title: 'Programas',
                actionText: 'Ver todos',
                onActionPressed: () {},
              ),
              
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _programs.length,
                  itemBuilder: (context, index) {
                    final program = _programs[index];
                    return SizedBox(
                      width: 300,
                      child: ProgramCard(
                        name: program.name,
                        durationWeeks: program.durationWeeks,
                        rating: program.rating,
                        totalReviews: program.totalReviews,
                        imageUrl: program.imageUrl,
                        isPopular: program.isPopular,
                        onTap: () => AppRoutes.goToProgramDetail(context, program.id),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Filtros de grupo muscular
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rutinas por Músculo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'Todos'),
                          _buildFilterChip('chest', 'Pecho'),
                          _buildFilterChip('back', 'Espalda'),
                          _buildFilterChip('legs', 'Piernas'),
                          _buildFilterChip('arms', 'Brazos'),
                          _buildFilterChip('shoulders', 'Hombros'),
                          _buildFilterChip('core', 'Core'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Rutinas
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _getFilteredRoutines().length,
                itemBuilder: (context, index) {
                  final routine = _getFilteredRoutines()[index];
                  return RoutineCard(
                    name: routine.name,
                    muscleGroup: routine.muscleGroupTranslated,
                    durationMinutes: routine.durationMinutes,
                    calories: routine.estimatedCalories,
                    imageUrl: routine.thumbnailUrl,
                    isLocked: routine.isPremium,
                    onTap: () => AppRoutes.goToRoutineDetail(context, routine.id),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedMuscleGroup == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedMuscleGroup = value;
          });
        },
        backgroundColor: ColorPalette.cardBackground,
        selectedColor: ColorPalette.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : ColorPalette.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  List<Routine> _getFilteredRoutines() {
    if (_selectedMuscleGroup == 'all') return _routines;
    return _routines
        .where((r) => r.muscleGroup == _selectedMuscleGroup)
        .toList();
  }
}
