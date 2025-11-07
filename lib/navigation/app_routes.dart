import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivofit/screens/onboarding_screen.dart';
import 'package:vivofit/screens/auth/login_screen.dart';
import 'package:vivofit/screens/auth/register_screen.dart';
import 'package:vivofit/screens/auth/forgot_password_screen.dart';
import 'package:vivofit/screens/main_screen.dart';
import 'package:vivofit/screens/home/program_detail_screen.dart';
import 'package:vivofit/screens/home/routine_detail_screen.dart';
import 'package:vivofit/screens/nutrition/food_detail_screen.dart';
import 'package:vivofit/screens/blog/article_detail_screen.dart';
import 'package:vivofit/screens/profile/edit_profile_screen.dart';
import 'package:vivofit/screens/membership/activate_membership_screen.dart';
import 'package:vivofit/screens/payment/payment_screen.dart';
import 'package:vivofit/screens/analytics/analytics_screen.dart';

/// Configuración de rutas de la aplicación usando GoRouter
class AppRoutes {
  // Nombres de rutas
  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String programDetail = '/program/:id';
  static const String routineDetail = '/routine/:id';
  static const String foodDetail = '/food/:id';
  static const String articleDetail = '/article/:id';
  static const String editProfile = '/profile/edit';
  static const String activateMembership = '/membership/activate';
  static const String payment = '/payment/:programId';
  static const String analytics = '/analytics';

  /// Configuración de GoRouter
  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Verificar si el usuario ya tiene sesión activa
      final user = Supabase.instance.client.auth.currentUser;
      final isAuthenticated = user != null;
      
      final isOnAuthScreen = state.matchedLocation == login || 
                           state.matchedLocation == register ||
                           state.matchedLocation == forgotPassword ||
                           state.matchedLocation == onboarding;
      
      // Si está autenticado y está en pantalla de auth, redirigir a home
      if (isAuthenticated && isOnAuthScreen) {
        return main;
      }
      
      // Si no está autenticado y no está en pantalla de auth, redirigir a onboarding
      if (!isAuthenticated && !isOnAuthScreen && state.matchedLocation != onboarding) {
        return onboarding;
      }
      
      // No hay redirección necesaria
      return null;
    },
    routes: [
      // Onboarding
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Autenticación
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main (Home, Nutrición, Blog, Perfil)
      GoRoute(
        path: main,
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'];
          return MainScreen(initialTab: tab != null ? int.tryParse(tab) : null);
        },
      ),

      // Detalles de Programa
      GoRoute(
        path: programDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProgramDetailScreen(programId: id);
        },
      ),

      // Detalles de Rutina
      GoRoute(
        path: routineDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RoutineDetailScreen(routineId: id);
        },
      ),

      // Detalles de Alimento
      GoRoute(
        path: foodDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FoodDetailScreen(foodId: id);
        },
      ),

      // Detalles de Artículo
      GoRoute(
        path: articleDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ArticleDetailScreen(articleId: id);
        },
      ),

      // Editar Perfil
      GoRoute(
        path: editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),

      // Activar Membresía
      GoRoute(
        path: activateMembership,
        builder: (context, state) {
          final programId = state.uri.queryParameters['programId'];
          return ActivateMembershipScreen(programId: programId);
        },
      ),

      // Pago
      GoRoute(
        path: payment,
        builder: (context, state) {
          final programId = state.pathParameters['programId']!;
          return PaymentScreen(programId: programId);
        },
      ),

      // Analítica y Progreso
      GoRoute(
        path: analytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
    ],

    // Manejo de errores de navegación
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(state.error.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(main),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),
  );

  // Métodos auxiliares para navegación

  /// Navega a la pantalla principal con un tab específico
  static void goToMainWithTab(BuildContext context, int tab) {
    context.go('$main?tab=$tab');
  }

  /// Navega al detalle de un programa
  static void goToProgramDetail(BuildContext context, String programId) {
    context.push(programDetail.replaceFirst(':id', programId));
  }

  /// Navega al detalle de una rutina
  static void goToRoutineDetail(BuildContext context, String routineId) {
    context.push(routineDetail.replaceFirst(':id', routineId));
  }

  /// Navega al detalle de un alimento
  static void goToFoodDetail(BuildContext context, String foodId) {
    context.push(foodDetail.replaceFirst(':id', foodId));
  }

  /// Navega al detalle de un artículo
  static void goToArticleDetail(BuildContext context, String articleId) {
    context.push(articleDetail.replaceFirst(':id', articleId));
  }

  /// Navega a la pantalla de pago
  static void goToPayment(BuildContext context, String programId) {
    context.push(payment.replaceFirst(':programId', programId));
  }

  /// Navega a activar membresía
  static void goToActivateMembership(BuildContext context,
      {String? programId}) {
    final uri = programId != null
        ? '$activateMembership?programId=$programId'
        : activateMembership;
    context.push(uri);
  }
}
