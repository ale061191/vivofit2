import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/services/auth_service.dart';
import 'package:vivofit/services/user_service.dart';
import 'package:vivofit/theme/app_theme.dart';

void main() {
  runApp(const VivofitApp());
}

/// Aplicación principal Vivofit
/// Implementa Provider para gestión de estado global
class VivofitApp extends StatelessWidget {
  const VivofitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: MaterialApp.router(
        title: 'Vivofit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRoutes.router,
        locale: const Locale('es', 'VE'), // Configurado para Venezuela
      ),
    );
  }
}
