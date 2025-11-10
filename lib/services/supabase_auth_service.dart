import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivofit/config/supabase_config.dart';

/// Clase base para servicios de Supabase
abstract class SupabaseBaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  SupabaseClient get client => _supabase;

  /// Manejo de errores comunes
  void handleError(dynamic error) {
    debugPrint('Error en servicio Supabase: $error');
  }
}

/// Servicio de autenticación con Supabase
/// Gestiona login, registro, sesión y cierre de sesión
class SupabaseAuthService extends SupabaseBaseService with ChangeNotifier {
  /// Usuario actualmente autenticado
  User? get currentUser => client.auth.currentUser;

  /// ID del usuario actual
  String? get currentUserId => currentUser?.id;

  /// Email del usuario actual
  String? get currentUserEmail => currentUser?.email;

  /// Verifica si hay un usuario autenticado
  bool get isAuthenticated => currentUser != null;

  SupabaseAuthService() {
    // Escuchar cambios en el estado de autenticación
    client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  /// Registrar nuevo usuario
  /// Retorna el ID del usuario si tiene éxito
  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Registrar usuario en Supabase Auth
      final AuthResponse response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );

      if (response.user == null) {
        throw Exception('Error al crear usuario');
      }

      final userId = response.user!.id;

      debugPrint('🔐 Usuario registrado en Auth: $userId');
      debugPrint('📧 Email: $email, Nombre: $name');

      // Crear registro en la tabla users INMEDIATAMENTE después del registro
      // Esto asegura que el usuario siempre tenga un perfil completo
      try {
        debugPrint('➕ Creando perfil en tabla users...');

        await client.from(SupabaseConfig.usersTable).insert({
          'id': userId,
          'email': email,
          'name': name,
          'created_at': DateTime.now().toIso8601String(),
        });

        debugPrint('✅ Perfil de usuario creado exitosamente en tabla users');
        debugPrint('✅ Usuario puede editar su perfil sin problemas');
      } catch (insertError) {
        debugPrint('❌ Error al crear perfil en tabla users: $insertError');
        debugPrint('⚠️ El usuario existe en Auth pero no en tabla users');
        debugPrint('⚠️ Esto causará problemas al editar perfil');

        // CRÍTICO: Si falla aquí, intentar eliminar el usuario de Auth
        // para evitar inconsistencia entre Auth y tabla users
        try {
          debugPrint('🔄 Intentando rollback de Auth...');
          await client.auth.signOut();
          throw Exception(
              'Error al crear perfil. Por favor verifica las políticas RLS de Supabase e intenta nuevamente.');
        } catch (rollbackError) {
          debugPrint('❌ Error en rollback: $rollbackError');
          throw Exception(
              'Error crítico al crear perfil. Contacta al administrador.');
        }
      }

      // Si la confirmación de email está deshabilitada, el usuario ya está autenticado
      // Si está habilitada, necesitará confirmar su email primero
      debugPrint(
          '📧 Email confirmado: ${response.user!.emailConfirmedAt != null}');

      notifyListeners();
      return userId;
    } on AuthException catch (e) {
      debugPrint('Error de autenticación en registro: ${e.message}');
      throw Exception('Error al registrar: ${e.message}');
    } catch (e) {
      debugPrint('Error en registro: $e');
      throw Exception('Error al registrar usuario');
    }
  }

  /// Iniciar sesión
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return false;
      }

      notifyListeners();
      return true;
    } on AuthException catch (e) {
      debugPrint('Error de autenticación en login: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Error en login: $e');
      return false;
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    try {
      await client.auth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      throw Exception('Error al cerrar sesión');
    }
  }

  /// Recuperar contraseña
  Future<bool> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      debugPrint('Error al recuperar contraseña: $e');
      return false;
    }
  }

  /// Verificar si el email ya está registrado
  Future<bool> emailExists(String email) async {
    try {
      final response = await client
          .from(SupabaseConfig.usersTable)
          .select('id')
          .eq('email', email)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('Error al verificar email: $e');
      return false;
    }
  }
}
