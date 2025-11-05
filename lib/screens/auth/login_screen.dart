import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/services/supabase_auth_service.dart';
import 'package:vivofit/services/supabase_user_service.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/utils/validators.dart';

/// Pantalla de Login con Supabase
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<SupabaseAuthService>();
    final userService = context.read<SupabaseUserService>();

    try {
      final success = await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // Cargar datos del usuario desde Supabase
        await userService.getCurrentUser();

        if (!mounted) return;
        context.go(AppRoutes.main);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas'),
            backgroundColor: ColorPalette.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: ColorPalette.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo de Vivofit
                Center(
                  child: Image.asset(
                    'assets/images/logo/vivofit-logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback si el logo no se carga
                      return const Icon(
                        Icons.fitness_center,
                        size: 80,
                        color: ColorPalette.primary,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'VIVOFIT',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Inicia sesión para continuar',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ColorPalette.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 16),

                // Contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      Validators.password(value, minLength: 6),
                  onFieldSubmitted: (_) => _handleLogin(),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Olvidé mi contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomTextButton(
                    text: '¿Olvidaste tu contraseña?',
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                  ),
                ),

                const SizedBox(height: 24),

                // Botón de login
                Consumer<SupabaseUserService>(
                  builder: (context, userService, _) {
                    return CustomButton(
                      text: 'Iniciar Sesión',
                      onPressed: _handleLogin,
                      isLoading: userService.isLoading,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Registrarse
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes cuenta? ',
                      style: TextStyle(color: ColorPalette.textSecondary),
                    ),
                    CustomTextButton(
                      text: 'Regístrate',
                      onPressed: () => context.go(AppRoutes.register),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Info de prueba con Supabase
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorPalette.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '🚀 Conectado con Supabase',
                        style: TextStyle(
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Regístrate para crear tu cuenta',
                        style: TextStyle(
                          color: ColorPalette.textSecondary,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'o usa credenciales de prueba si las creaste',
                        style: TextStyle(
                          color: ColorPalette.textSecondary,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
