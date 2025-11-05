import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivofit/config/supabase_config.dart';

/// Servicio de autenticación con Supabase
/// Gestiona login, registro, sesión y cierre de sesión
class SupabaseAuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Usuario actualmente autenticado
  User? get currentUser => _supabase.auth.currentUser;

  /// ID del usuario actual
  String? get currentUserId => currentUser?.id;

  /// Email del usuario actual
  String? get currentUserEmail => currentUser?.email;

  /// Verifica si hay un usuario autenticado
  bool get isAuthenticated => currentUser != null;

  SupabaseAuthService() {
    // Escuchar cambios en el estado de autenticación
    _supabase.auth.onAuthStateChange.listen((data) {
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
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );

      if (response.user == null) {
        throw Exception('Error al crear usuario');
      }

      // Crear registro en la tabla users usando función RPC que bypasea RLS
      // No necesitamos esperar autenticación porque la función usa SECURITY DEFINER
      try {
        await _supabase.rpc('create_user_profile', params: {
          'user_id': response.user!.id,
          'user_email': email,
          'user_name': name,
        });
        debugPrint('✅ Perfil de usuario creado exitosamente via RPC');
      } catch (insertError) {
        debugPrint('❌ Error al crear perfil via RPC: $insertError');
        // Continuar de todos modos, el usuario existe en Auth
      }

      // Si la confirmación de email está deshabilitada, el usuario ya está autenticado
      // Si está habilitada, necesitará confirmar su email primero
      debugPrint('Usuario registrado: ${response.user!.id}');
      debugPrint(
          'Email confirmado: ${response.user!.emailConfirmedAt != null}');

      notifyListeners();
      return response.user!.id;
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
      final AuthResponse response = await _supabase.auth.signInWithPassword(
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
      await _supabase.auth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      throw Exception('Error al cerrar sesión');
    }
  }

  /// Recuperar contraseña
  Future<bool> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      debugPrint('Error al recuperar contraseña: $e');
      return false;
    }
  }

  /// Verificar si el email ya está registrado
  Future<bool> emailExists(String email) async {
    try {
      final response = await _supabase
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
