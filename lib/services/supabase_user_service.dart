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

  /// Obtener perfil de un usuario específico por ID
  Future<app_user.User?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.usersTable)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        debugPrint('⚠️ Usuario $userId no encontrado');
        return null;
      }

      return _userFromSupabase(response);
    } catch (e) {
      debugPrint('❌ Error al obtener perfil de usuario $userId: $e');
      return null;
    }
  }

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
          'name':
              authUser.userMetadata?['name'] ?? authUser.email!.split('@')[0],
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
        // Cast explícito para resolver el error de tipo Object?
        _currentUser = _userFromSupabase(response);
      }

      debugPrint(
          '✅ Usuario cargado: ${_currentUser?.name} (${_currentUser?.email})');
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
            name:
                authUser.userMetadata?['name'] ?? authUser.email!.split('@')[0],
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
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        debugPrint('❌ No hay usuario autenticado para actualizar');
        return false;
      }

      final userId = authUser.id;

      debugPrint('🔍 Verificando existencia de usuario: $userId');

      // 1. Verificar si el usuario ya existe en la tabla
      final existingUser = await _supabase
          .from(SupabaseConfig.usersTable)
          .select('id, email, name, gender, created_at')
          .eq('id', userId)
          .maybeSingle();

      final existingGender = existingUser?['gender'] as String?;
      final normalizedExistingGender = _normalizeGender(existingGender);
      final normalizedGenderInput = _normalizeGender(gender);

      // 2. Preparar datos comunes
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (height != null) data['height'] = height;
      if (weight != null) data['weight'] = weight;
      if (age != null) data['age'] = age;
      if (normalizedGenderInput != null) {
        data['gender'] = normalizedGenderInput;
      } else if (existingGender != null) {
        if (normalizedExistingGender != null &&
            normalizedExistingGender != existingGender) {
          data['gender'] = normalizedExistingGender;
        } else if (normalizedExistingGender == null) {
          data['gender'] = null;
        }
      }
      if (location != null) data['location'] = location;

      debugPrint('📝 Datos a guardar: $data');

      // 3. Ejecutar INSERT o UPDATE según corresponda
      if (existingUser == null) {
        // Usuario NO existe en tabla users (ERROR CRÍTICO de registro)
        // Esto NO DEBERÍA pasar si el registro funciona correctamente
        debugPrint(
            '⚠️⚠️⚠️ ALERTA: Usuario existe en Auth pero NO en tabla users');
        debugPrint('🔧 Creando registro faltante...');

        final insertData = Map<String, dynamic>.from(data)
          ..putIfAbsent(
            'name',
            () => authUser.userMetadata?['name'] ??
                authUser.email!.split('@')[0],
          )
          ..putIfAbsent('gender', () => normalizedGenderInput)
          ..putIfAbsent('id', () => userId)
          ..putIfAbsent('email', () => authUser.email!)
          ..putIfAbsent(
            'created_at',
            () => DateTime.now().toIso8601String(),
          );

        await _supabase.from(SupabaseConfig.usersTable).insert(insertData);

        debugPrint('✅ Perfil creado exitosamente (recuperación de error)');
      } else {
        // Usuario SÍ existe → UPDATE (flujo normal)
        debugPrint('✏️ Usuario existe en tabla users, actualizando...');
        debugPrint('📋 Datos actuales: $existingUser');

        final updateData = Map<String, dynamic>.from(data)
          ..['updated_at'] = DateTime.now().toIso8601String();

        await _supabase
            .from(SupabaseConfig.usersTable)
            .update(updateData)
            .eq('id', userId);

        debugPrint('✅ Perfil actualizado exitosamente');
      }

      // 4. Recargar datos del usuario para reflejar cambios
      await getCurrentUser();

      debugPrint(
          '✅ Usuario recargado: ${_currentUser?.name}, edad: ${_currentUser?.age}, altura: ${_currentUser?.height}, peso: ${_currentUser?.weight}');

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error al actualizar perfil: $e');
      debugPrint('📍 Stack trace: $stackTrace');
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
      gender: _normalizeGender(data['gender'] as String?),
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

  String? _normalizeGender(String? value) {
    if (value == null) return null;
    final normalized = value.toString().trim().toLowerCase();

    switch (normalized) {
      case 'male':
      case 'masculino':
        return 'male';
      case 'female':
      case 'femenino':
        return 'female';
      case 'other':
      case 'otro':
        return 'other';
      default:
        return null;
    }
  }
}
