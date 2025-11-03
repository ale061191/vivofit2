import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio para manejar llamadas a la API
/// Centraliza toda la comunicación con el backend
class ApiService {
  // TODO: Configurar URL base del servidor
  static const String baseUrl = 'https://api.vivofit.com/v1';
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Headers por defecto
  static Map<String, String> _getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Realiza una petición GET
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    String? token,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl$endpoint');
      
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http
          .get(uri, headers: _getHeaders(token: token))
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Realiza una petición POST
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http
          .post(
            uri,
            headers: _getHeaders(token: token),
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Realiza una petición PUT
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http
          .put(
            uri,
            headers: _getHeaders(token: token),
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Realiza una petición DELETE
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http
          .delete(uri, headers: _getHeaders(token: token))
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Maneja la respuesta de la API
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    }

    // Manejo de errores HTTP
    String errorMessage;
    try {
      final errorBody = jsonDecode(response.body);
      errorMessage = errorBody['message'] ?? errorBody['error'] ?? 'Error desconocido';
    } catch (_) {
      errorMessage = 'Error del servidor (${response.statusCode})';
    }

    throw ApiException(
      message: errorMessage,
      statusCode: statusCode,
    );
  }

  /// Maneja errores de conexión
  static Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }

    if (error.toString().contains('TimeoutException')) {
      return ApiException(
        message: 'Tiempo de espera agotado. Verifica tu conexión.',
        statusCode: 0,
      );
    }

    if (error.toString().contains('SocketException')) {
      return ApiException(
        message: 'Sin conexión a internet',
        statusCode: 0,
      );
    }

    return ApiException(
      message: 'Error de conexión: $error',
      statusCode: 0,
    );
  }

  // Endpoints específicos de la aplicación

  /// Autenticación
  static Future<Map<String, dynamic>> login(String email, String password) {
    return post('/auth/login', body: {
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) {
    return post('/auth/register', body: {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> resetPassword(String email) {
    return post('/auth/reset-password', body: {'email': email});
  }

  /// Usuario
  static Future<Map<String, dynamic>> getUser(String userId, String token) {
    return get('/users/$userId', token: token);
  }

  static Future<Map<String, dynamic>> updateUser(
    String userId,
    Map<String, dynamic> data,
    String token,
  ) {
    return put('/users/$userId', body: data, token: token);
  }

  /// Programas
  static Future<Map<String, dynamic>> getPrograms({String? token}) {
    return get('/programs', token: token);
  }

  static Future<Map<String, dynamic>> getProgram(String programId, {String? token}) {
    return get('/programs/$programId', token: token);
  }

  /// Rutinas
  static Future<Map<String, dynamic>> getRoutines({String? muscleGroup, String? token}) {
    final params = muscleGroup != null ? {'muscleGroup': muscleGroup} : null;
    return get('/routines', queryParams: params, token: token);
  }

  static Future<Map<String, dynamic>> getRoutine(String routineId, String token) {
    return get('/routines/$routineId', token: token);
  }

  /// Alimentos
  static Future<Map<String, dynamic>> getFoods({String? category, String? search}) {
    final params = <String, String>{};
    if (category != null) params['category'] = category;
    if (search != null) params['search'] = search;
    return get('/foods', queryParams: params.isNotEmpty ? params : null);
  }

  static Future<Map<String, dynamic>> getFood(String foodId) {
    return get('/foods/$foodId');
  }

  /// Artículos
  static Future<Map<String, dynamic>> getArticles({String? topic}) {
    final params = topic != null ? {'topic': topic} : null;
    return get('/articles', queryParams: params);
  }

  static Future<Map<String, dynamic>> getArticle(String articleId) {
    return get('/articles/$articleId');
  }

  /// Membresías
  static Future<Map<String, dynamic>> getMemberships(String userId, String token) {
    return get('/users/$userId/memberships', token: token);
  }

  static Future<Map<String, dynamic>> activateMembership(
    String userId,
    String programId,
    String token,
  ) {
    return post(
      '/users/$userId/memberships',
      body: {'programId': programId},
      token: token,
    );
  }

  /// Pagos
  static Future<Map<String, dynamic>> createPayment(
    Map<String, dynamic> paymentData,
    String token,
  ) {
    return post('/payments', body: paymentData, token: token);
  }

  static Future<Map<String, dynamic>> getPayments(String userId, String token) {
    return get('/users/$userId/payments', token: token);
  }

  /// Subir imagen
  static Future<String> uploadImage(String filePath, String token) async {
    // TODO: Implementar subida de imagen
    // Usar multipart/form-data para subir archivo
    throw UnimplementedError('Subida de imágenes no implementada');
  }
}

/// Excepción personalizada para errores de API
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => message;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;
  bool get isNetworkError => statusCode == 0;
}
