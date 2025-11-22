import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/services/supabase_user_service.dart';
import 'package:vivofit/services/supabase_auth_service.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/utils/test_data_generator.dart';
import 'package:vivofit/models/bmi_progress.dart';
import 'package:vivofit/widgets/analytics/bmi_progress_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Pantalla de Perfil
/// Rediseñada estilo "Social Profile" (Ref: Duolingo style)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BMIProgress? _bmiProgress;
  bool _isLoadingBMI = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserAndBMI();
    });
  }

  Future<void> _loadUserAndBMI() async {
    // Primero cargar usuario
    final userService = context.read<SupabaseUserService>();
    await userService.getCurrentUser();

    // Luego cargar BMI
    _loadBMIProgress();
  }

  Future<void> _loadBMIProgress() async {
    try {
      final userService = context.read<SupabaseUserService>();

      // El usuario ya debería estar cargado en el servicio
      final user = userService.currentUser;

      if (user == null || user.height == null || user.weight == null) {
        if (mounted) {
          setState(() {
            _isLoadingBMI = false;
          });
        }
        return;
      }

      // TODO: Cuando migres workout service, usa el de Supabase
      // Por ahora, usar valores por defecto
      const totalCalories = 0;
      final currentBMI = user.imc ?? 0;

      // Simular peso inicial basado en calorías quemadas
      const weightEquivalentBurned = totalCalories / 7700;
      final initialWeight = user.weight! + weightEquivalentBurned;
      final heightInMeters = user.height! / 100;
      final initialBMI = initialWeight / (heightInMeters * heightInMeters);

      final bmiProgress = BMIProgress.initial(
        currentBMI: currentBMI,
        currentWeight: user.weight!,
        height: user.height!,
      ).copyWith(
        initialBMI: initialBMI,
        initialWeight: initialWeight,
        totalCaloriesBurned: totalCalories,
        lastUpdateDate: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _bmiProgress = bmiProgress;
          _isLoadingBMI = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading BMI progress: $e');
      if (mounted) {
        setState(() {
          _isLoadingBMI = false;
        });
      }
      debugPrint('Error loading BMI progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: ColorPalette.textSecondary),
            onPressed: () async {
              // Navegar a editar perfil (donde están los datos personales)
              await context.push(AppRoutes.editProfile);
              // Recargar datos cuando regresa de editar
              if (mounted) {
                await _loadUserAndBMI();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<SupabaseUserService>(
        builder: (context, userService, _) {
          // Mostrar loading mientras carga
          if (userService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userService.currentUser;

          if (user == null) {
            return const Center(
              child: Text('No se pudo cargar el perfil'),
            );
          }

          final imc = user.imc;
          final imcCategory = user.imcCategory;
          final joinedDate =
              DateFormat('MMMM yyyy', 'es_ES').format(user.createdAt);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Redirigir a editar perfil para cambiar foto
                          context.push(AppRoutes.editProfile);
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: ColorPalette.primary,
                              backgroundImage: user.photoUrl != null
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null
                                  ? const Icon(Icons.person,
                                      size: 60, color: Colors.black)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: ColorPalette.background,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: ColorPalette.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email, // O username si existiera
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Se unió en $joinedDate',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- STATS ROW ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      icon: Icons.local_fire_department,
                      value: '0', // TODO: Real streak
                      label: 'Racha',
                      color: Colors.orange,
                    ),
                    Container(
                        width: 1,
                        height: 40,
                        color: ColorPalette.cardBackground),
                    _buildStatItem(
                      icon: Icons.shield,
                      value: 'Nivel 1', // TODO: Real level
                      label: 'Principiante',
                      color: Colors.blue,
                    ),
                    Container(
                        width: 1,
                        height: 40,
                        color: ColorPalette.cardBackground),
                    _buildStatItem(
                      icon: Icons.group,
                      value: '0', // TODO: Real followers
                      label: 'Seguidores',
                      color: Colors.green,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- ACTION BUTTONS ---
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Compartir Perfil',
                        onPressed: () {
                          // TODO: Implement share
                        },
                        icon: Icons.share,
                        isOutlined: true,
                        height: 45,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // --- RESUMEN SECTION ---
                const Text(
                  'Resumen',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // IMC Card y Gráfico
                if (imc != null && !_isLoadingBMI && _bmiProgress != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMC Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Acceso rápido a editar peso/altura
                            context.push(AppRoutes.editProfile);
                          },
                          child: Container(
                            height: 180,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ColorPalette.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ColorPalette.cardBackground,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.monitor_weight_outlined,
                                    color: ColorPalette.primary, size: 28),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tu IMC',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  imc.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  imcCategory,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getImcColor(imc),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Gráfico de progreso de IMC
                      Expanded(
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: ColorPalette.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BMIProgressChart(
                              bmiProgress: _bmiProgress!,
                              showDetails: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                // Si no hay datos de IMC
                if (imc == null && !_isLoadingBMI)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ColorPalette.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: ColorPalette.primary, size: 48),
                        const SizedBox(height: 16),
                        const Text(
                          'Completa tu perfil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Agrega tu peso y altura para ver tu análisis de IMC.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ColorPalette.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Completar Datos',
                          onPressed: () => context.push(AppRoutes.editProfile),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // --- MIS MEMBRESÍAS ---
                CustomButton(
                  text: 'Mis Membresías (${user.activeMemberships.length})',
                  onPressed: () => AppRoutes.goToActivateMembership(context),
                  icon: Icons.card_membership,
                  backgroundColor: ColorPalette.cardBackground,
                  textColor: ColorPalette.primary,
                  isOutlined: true,
                ),

                const SizedBox(height: 16),

                // Botón para generar datos de prueba (solo desarrollo)
                CustomButton(
                  text: 'Generar Datos de Prueba',
                  onPressed: () =>
                      TestDataGenerator.showGenerateDataDialog(context),
                  icon: Icons.auto_graph,
                  backgroundColor: Colors.transparent,
                  textColor: ColorPalette.textSecondary,
                  isOutlined: true,
                ),

                const SizedBox(height: 16),

                // Cerrar sesión
                CustomButton(
                  text: 'Cerrar Sesión',
                  onPressed: () async {
                    await context.read<SupabaseAuthService>().logout();
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                    }
                  },
                  icon: Icons.logout,
                  backgroundColor: ColorPalette.error.withOpacity(0.1),
                  textColor: ColorPalette.error,
                  isOutlined: true,
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorPalette.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ColorPalette.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getImcColor(double imc) {
    if (imc < 18.5) return Colors.blue;
    if (imc < 25) return Colors.green;
    if (imc < 30) return Colors.orange;
    return Colors.red;
  }
}
