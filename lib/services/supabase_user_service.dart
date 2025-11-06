import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivofit/config/supabase_config.dart';
import 'package:vivofit/models/user.dart' as app_user;

/// Servicio de gestión de usuarios con Supabase
/// Maneja perfil de usuario, IMC y datos personales
class SupabaseUserService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  app_user.User? _currentUser;
  bool _isLoading = false;

  app_user.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  /// Obtener datos del usuario actual
  Future<app_user.User?> getCurrentUser() async {
    try {
      _isLoading = true;
      notifyListeners();

      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        debugPrint('❌ No hay usuario autenticado');
        _currentUser = null;
        return null;
      }

      debugPrint('✅ Usuario autenticado: ${authUser.id}');

      final response = await _supabase
          .from(SupabaseConfig.usersTable)
          .select()
          .eq('id', authUser.id)
          .maybeSingle(); // Usar maybeSingle en lugar de single

      if (response == null) {
        debugPrint('⚠️ Usuario no encontrado en tabla users, creando...');
        // Si no existe el registro, crearlo
        await _supabase.from(SupabaseConfig.usersTable).insert({
          'id': authUser.id,
          'email': authUser.email!,
          'name': authUser.userMetadata?['name'] ?? authUser.email!.split('@')[0],
          'created_at': DateTime.now().toIso8601String(),
        });
        
        // Volver a consultar
        final newResponse = await _supabase
            .from(SupabaseConfig.usersTable)
            .select()
            .eq('id', authUser.id)
            .single();
        
        _currentUser = _userFromSupabase(newResponse);
      } else {
        _currentUser = _userFromSupabase(response);
      }

      debugPrint('✅ Usuario cargado: ${_currentUser?.name} (${_currentUser?.email})');
      return _currentUser;
    } catch (e) {
      debugPrint('❌ Error al obtener usuario: $e');
      // Intentar crear usuario básico con datos de auth
      try {
        final authUser = _supabase.auth.currentUser;
        if (authUser != null) {
          _currentUser = app_user.User(
            id: authUser.id,
            email: authUser.email!,
            name: authUser.userMetadata?['name'] ?? authUser.email!.split('@')[0],
          );
          return _currentUser;
        }
      } catch (fallbackError) {
        debugPrint('❌ Error en fallback: $fallbackError');
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualizar perfil del usuario
  Future<bool> updateProfile({
    String? name,
    String? phone,
    double? height,
    double? weight,
    int? age,
    String? gender,
    String? location,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (height != null) updates['height'] = height;
      if (weight != null) updates['weight'] = weight;
      if (age != null) updates['age'] = age;
      if (gender != null) updates['gender'] = gender;
      if (location != null) updates['location'] = location;

      if (updates.isEmpty) return true;

      await _supabase
          .from(SupabaseConfig.usersTable)
          .update(updates)
          .eq('id', userId);

      // Recargar datos del usuario
      await getCurrentUser();

      return true;
    } catch (e) {
      debugPrint('Error al actualizar perfil: $e');
      return false;
    }
  }

  /// Calcular y guardar IMC
  Future<double?> calculateAndSaveBMI() async {
    try {
      if (_currentUser == null) {
        await getCurrentUser();
      }

      if (_currentUser?.height == null || _currentUser?.weight == null) {
        return null;
      }

      final heightInMeters = _currentUser!.height! / 100;
      final bmi = _currentUser!.weight! / (heightInMeters * heightInMeters);

      // Guardar en historial de IMC
      await _supabase.from(SupabaseConfig.bmiHistoryTable).insert({
        'user_id': _supabase.auth.currentUser?.id,
        'bmi_value': bmi,
        'weight': _currentUser!.weight,
        'height': _currentUser!.height,
        'total_calories_burned': 0, // Se actualizará con workouts
      });

      return bmi;
    } catch (e) {
      debugPrint('Error al calcular IMC: $e');
      return null;
    }
  }

  /// Obtener historial de IMC
  Future<List<Map<String, dynamic>>> getBMIHistory({int limit = 30}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from(SupabaseConfig.bmiHistoryTable)
          .select()
          .eq('user_id', userId)
          .order('recorded_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error al obtener historial de IMC: $e');
      return [];
    }
  }

  /// Subir foto de perfil (filePath es la ruta local del archivo)
  /// Por ahora comentado hasta implementar la subida de imágenes
  /*
  Future<String?> uploadProfilePhoto(String filePath) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // TODO: Implementar subida de archivo desde web
      // await _supabase.storage
      //     .from(SupabaseConfig.profilePhotosBucket)
      //     .upload(fileName, File(filePath));

      final photoUrl = _supabase.storage
          .from(SupabaseConfig.profilePhotosBucket)
          .getPublicUrl(fileName);

      // Actualizar URL en base de datos
      await _supabase
          .from(SupabaseConfig.usersTable)
          .update({'photo_url': photoUrl}).eq('id', userId);

      await getCurrentUser();

      return photoUrl;
    } catch (e) {
      debugPrint('Error al subir foto de perfil: $e');
      return null;
    }
  }
  */

  /// Convertir datos de Supabase a modelo User
  app_user.User _userFromSupabase(Map<String, dynamic> data) {
    return app_user.User(
      id: data['id'] as String,
      email: data['email'] as String,
      name: (data['name'] as String?) ?? '',
      phone: data['phone'] as String?,
      photoUrl: data['photo_url'] as String?,
      height: (data['height'] as num?)?.toDouble(),
      weight: (data['weight'] as num?)?.toDouble(),
      age: data['age'] as int?,
      gender: data['gender'] as String?,
      location: data['location'] as String?,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
    );
  }

  /// Limpiar datos del usuario
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
