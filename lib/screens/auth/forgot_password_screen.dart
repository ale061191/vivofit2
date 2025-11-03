import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/services/auth_service.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/utils/validators.dart';

/// Pantalla de Recuperación de Contraseña
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();
    final success = await authService.resetPassword(_emailController.text.trim());

    if (!mounted) return;

    if (success) {
      setState(() {
        _emailSent = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authService.error ?? 'Error al enviar email'),
          backgroundColor: ColorPalette.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.lock_reset,
            size: 80,
            color: ColorPalette.primary,
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Recuperar Contraseña',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Ingresa tu email y te enviaremos instrucciones para restablecer tu contraseña',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorPalette.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: Validators.email,
            onFieldSubmitted: (_) => _handleResetPassword(),
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Consumer<AuthService>(
            builder: (context, authService, _) {
              return CustomButton(
                text: 'Enviar Instrucciones',
                onPressed: _handleResetPassword,
                isLoading: authService.isLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          size: 100,
          color: ColorPalette.success,
        ),
        
        const SizedBox(height: 24),
        
        Text(
          '¡Email Enviado!',
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'Hemos enviado las instrucciones a tu correo electrónico',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorPalette.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
        CustomButton(
          text: 'Volver al Login',
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
