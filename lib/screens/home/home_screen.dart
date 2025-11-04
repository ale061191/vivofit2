import 'package:flutter/material.dart';
import 'package:vivofit/components/custom_cards.dart';
import 'package:vivofit/components/common_widgets.dart';
import 'package:vivofit/models/program.dart';
import 'package:vivofit/models/routine.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/widgets/analytics/progress_card.dart';

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
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section con imagen y logo
              _buildHeroSection(),

              const SizedBox(height: 24),

              // Tarjeta de progreso y analítica
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ProgressCard(),
              ),

              // Programas destacados
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.paddingMedium),
                child: SectionHeader(
                  title: 'Programas',
                  actionText: 'Ver todos',
                  onActionPressed: () {},
                ),
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
                        onTap: () =>
                            AppRoutes.goToProgramDetail(context, program.id),
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
                    onTap: () =>
                        AppRoutes.goToRoutineDetail(context, routine.id),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 240,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8), // Reducido en eje X, solo vertical
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Imagen de fondo a pantalla completa
            Positioned.fill(
              child: Image.asset(
                'assets/images/onboarding/image6.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorPalette.cardBackground,
                          ColorPalette.background,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.fitness_center,
                        size: 80,
                        color: ColorPalette.primary,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Gradiente oscuro para mejor contraste
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Contenido: Logo y texto
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo de VivoFit más pequeño
                  Image.asset(
                    'assets/images/logo/vivofit-logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: ColorPalette.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'VF',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 20),

                  // Texto motivacional
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Texto "PREPÁRATE PARA ENTRENAR"
                        const Text(
                          'PREPÁRATE PARA ENTRENAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: ColorPalette.textSecondary,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Descripción con icono
                        Row(
                          children: [
                            Container(
                              width: 3,
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: ColorPalette.primaryGradient,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Alcanza tus objetivos con rutinas personalizadas y profesionales',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: ColorPalette.textPrimary,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
