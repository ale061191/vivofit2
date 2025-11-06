import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/services/supabase_user_service.dart';
import 'package:vivofit/services/supabase_auth_service.dart';
import 'package:vivofit/services/supabase_workout_service.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/utils/test_data_generator.dart';
import 'package:vivofit/models/bmi_progress.dart';
import 'package:vivofit/widgets/analytics/bmi_progress_chart.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de Perfil
/// Muestra y permite editar información del usuario
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
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              // Navegar y esperar a que regrese
              await context.push(AppRoutes.editProfile);
              // Recargar datos cuando regresa de editar
              if (mounted) {
                await _loadUserAndBMI();
              }
            },
          ),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              children: [
                // Foto de perfil
                GestureDetector(
                  onTap: () {
                    // Redirigir a editar perfil para cambiar foto
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                  child: CircleAvatar(
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
                ),

                const SizedBox(height: 16),

                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 32),

                // IMC Card y Gráfico lado a lado
                if (imc != null && !_isLoadingBMI && _bmiProgress != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMC Card
                      Expanded(
                        child: Container(
                          height:
                              150, // Altura fija para igualar con el gráfico
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: ColorPalette.cardGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tu IMC',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorPalette.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                imc.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: ColorPalette.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                imcCategory,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorPalette.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Gráfico de progreso de IMC
                      Expanded(
                        child: BMIProgressChart(
                          bmiProgress: _bmiProgress!,
                          showDetails: false, // Versión compacta para el perfil
                        ),
                      ),
                    ],
                  ),

                // Si solo hay IMC sin gráfico, mostrar solo el card
                if (imc != null && (!_isLoadingBMI && _bmiProgress == null))
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: ColorPalette.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Tu IMC',
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorPalette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          imc.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.primary,
                          ),
                        ),
                        Text(
                          imcCategory,
                          style: const TextStyle(
                            fontSize: 16,
                            color: ColorPalette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Indicador de carga
                if (imc != null && _isLoadingBMI)
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: ColorPalette.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: ColorPalette.primary,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Botón Ver Análisis Completo (debajo de ambos cards)
                if (!_isLoadingBMI && _bmiProgress != null)
                  CustomButton(
                    text: 'Ver Análisis Completo',
                    onPressed: () => context.push('/analytics'),
                    icon: Icons.analytics_outlined,
                    isOutlined: true,
                  ),

                const SizedBox(height: 24),

                // Información personal
                _buildInfoRow(Icons.cake, 'Edad', '${user.age ?? "N/A"} años'),
                _buildInfoRow(
                    Icons.height, 'Altura', '${user.height ?? "N/A"} cm'),
                _buildInfoRow(
                    Icons.monitor_weight, 'Peso', '${user.weight ?? "N/A"} kg'),
                _buildInfoRow(
                    Icons.phone, 'Teléfono', user.phone ?? 'No especificado'),
                _buildInfoRow(Icons.location_on, 'Ubicación',
                    user.location ?? 'No especificado'),

                const SizedBox(height: 32),

                // Membresías activas
                CustomButton(
                  text: 'Mis Membresías (${user.activeMemberships.length})',
                  onPressed: () => AppRoutes.goToActivateMembership(context),
                  icon: Icons.card_membership,
                  isOutlined: true,
                ),

                const SizedBox(height: 16),

                // Botón para generar datos de prueba (solo desarrollo)
                CustomButton(
                  text: 'Generar Datos de Prueba',
                  onPressed: () =>
                      TestDataGenerator.showGenerateDataDialog(context),
                  icon: Icons.auto_graph,
                  backgroundColor: ColorPalette.cardBackground,
                  textColor: ColorPalette.primary,
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
                  backgroundColor: ColorPalette.error,
                  textColor: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: ColorPalette.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: ColorPalette.textTertiary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: ColorPalette.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
