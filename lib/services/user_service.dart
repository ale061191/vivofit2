import 'package:flutter/foundation.dart';
import 'package:vivofit/models/user.dart';
import 'package:image_picker/image_picker.dart';

/// Servicio de gestión de usuario
/// Maneja el perfil, actualización de datos y cálculos relacionados
class UserService extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carga los datos del usuario
  /// MOCK: En producción usar ApiService.getUser()
  Future<void> loadUser(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));

      _user = User.mock();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar usuario: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza el perfil del usuario
  /// MOCK: En producción usar ApiService.updateUser()
  Future<bool> updateProfile({
    String? name,
    int? age,
    double? height,
    double? weight,
    String? phone,
    String? location,
    String? gender,
  }) async {
    if (_user == null) {
      _setError('No hay usuario cargado');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));

      _user = _user!.copyWith(
        name: name ?? _user!.name,
        age: age ?? _user!.age,
        height: height ?? _user!.height,
        weight: weight ?? _user!.weight,
        phone: phone ?? _user!.phone,
        location: location ?? _user!.location,
        gender: gender ?? _user!.gender,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al actualizar perfil: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza la foto de perfil
  /// PENDIENTE: Integrar con servicio de almacenamiento en la nube
  Future<bool> updateProfilePhoto() async {
    if (_user == null) {
      _setError('No hay usuario cargado');
      return false;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image == null) {
        return false; // Usuario canceló
      }

      _setLoading(true);

      // Simular subida de imagen
      await Future.delayed(const Duration(seconds: 2));

      // En producción: usar ApiService.uploadImage() y obtener URL
      final photoUrl = 'https://via.placeholder.com/150';

      _user = _user!.copyWith(
        photoUrl: photoUrl,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al actualizar foto: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Activa una membresía para el usuario
  /// MOCK: En producción usar ApiService.activateMembership()
  Future<bool> activateMembership(String programId) async {
    if (_user == null) {
      _setError('No hay usuario cargado');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));

      final updatedMemberships = List<String>.from(_user!.activeMemberships);
      if (!updatedMemberships.contains(programId)) {
        updatedMemberships.add(programId);
      }

      _user = _user!.copyWith(
        activeMemberships: updatedMemberships,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al activar membresía: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verifica si el usuario tiene acceso a un programa
  bool hasMembership(String programId) {
    return _user?.hasMembership(programId) ?? false;
  }

  /// Obtiene el IMC del usuario
  double? getIMC() {
    return _user?.imc;
  }

  /// Obtiene la categoría de IMC del usuario
  String getIMCCategory() {
    return _user?.imcCategory ?? 'Sin datos';
  }

  /// Calcula las calorías diarias recomendadas
  double? getDailyCalories(String activityLevel) {
    if (_user == null) return null;

    // Implementar cálculo usando IMCCalculator
    // Por ahora retornar valor estimado
    return 2200;
  }

  /// Elimina la cuenta del usuario
  /// MOCK: En producción usar ApiService.deleteUser()
  Future<bool> deleteAccount() async {
    if (_user == null) {
      _setError('No hay usuario cargado');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));

      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al eliminar cuenta: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Métodos auxiliares

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

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
