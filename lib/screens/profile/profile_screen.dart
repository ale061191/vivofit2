import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/services/user_service.dart';
import 'package:vivofit/services/auth_service.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de Perfil
/// Muestra y permite editar información del usuario
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.editProfile),
          ),
        ],
      ),
      body: Consumer<UserService>(
        builder: (context, userService, _) {
          final user = userService.user;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
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

                // IMC Card
                if (imc != null)
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

                // Cerrar sesión
                CustomButton(
                  text: 'Cerrar Sesión',
                  onPressed: () async {
                    await context.read<AuthService>().logout();
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
