import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/services/auth_service.dart';
import 'package:vivofit/services/user_service.dart';
import 'package:vivofit/services/workout_tracker_service.dart';
import 'package:vivofit/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(VivofitApp(prefs: prefs));
}

/// Aplicación principal Vivofit
/// Implementa Provider para gestión de estado global
class VivofitApp extends StatelessWidget {
  final SharedPreferences prefs;

  const VivofitApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        Provider<WorkoutTrackerService>(
          create: (_) => WorkoutTrackerService(prefs),
        ),
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
