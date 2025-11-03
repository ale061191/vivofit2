import 'package:flutter/foundation.dart';
import 'package:vivofit/models/user.dart';

/// Servicio de autenticación
/// Maneja registro, login, logout y recuperación de contraseña
class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  /// Registra un nuevo usuario
  /// MOCK: En producción integrar con ApiService.register()
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));

      // Validar si el email ya existe (simulado)
      if (email == 'test@test.com') {
        _setError('Este email ya está registrado');
        return false;
      }

      // Crear usuario
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al registrar usuario: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Inicia sesión con email y contraseña
  /// MOCK: En producción integrar con ApiService.login()
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));

      // Validación simulada
      if (email == 'demo@vivofit.com' && password == '123456') {
        _currentUser = User.mock();
        notifyListeners();
        return true;
      }

      _setError('Credenciales incorrectas');
      return false;
    } catch (e) {
      _setError('Error al iniciar sesión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    _setLoading(true);

    try {
      // Simular limpieza de sesión
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = null;
      _error = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Recupera la contraseña del usuario
  /// MOCK: En producción integrar con ApiService.resetPassword()
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simular envío de email
      await Future.delayed(const Duration(seconds: 2));

      // Validar que el email exista
      if (email.isEmpty || !email.contains('@')) {
        _setError('Email inválido');
        return false;
      }

      // Email enviado exitosamente
      return true;
    } catch (e) {
      _setError('Error al enviar email de recuperación: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cambia la contraseña del usuario
  /// MOCK: En producción integrar con ApiService.changePassword()
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      _setError('No hay usuario autenticado');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Simular cambio de contraseña
      await Future.delayed(const Duration(seconds: 1));

      // Validar contraseña actual (simulado)
      if (currentPassword != '123456') {
        _setError('Contraseña actual incorrecta');
        return false;
      }

      return true;
    } catch (e) {
      _setError('Error al cambiar contraseña: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza el token de sesión
  /// PENDIENTE: Implementar refresh token con JWT
  Future<void> refreshToken() async {
    // Implementar lógica de refresh token
  }

  /// Verifica si hay una sesión guardada
  /// PENDIENTE: Implementar persistencia con SharedPreferences
  Future<void> checkSession() async {
    _setLoading(true);

    try {
      // Simular verificación de sesión
      await Future.delayed(const Duration(seconds: 1));

      // Por ahora, cargar usuario mockeado
      // _currentUser = User.mock();
      // notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Métodos auxiliares

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    if (error != null) {
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
