import 'package:email_validator/email_validator.dart';

/// Clase base para validadores comunes
abstract class BaseValidators {
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    return null;
  }
}

/// Validadores específicos para formularios
class Validators extends BaseValidators {
  /// Valida formato de email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    if (!EmailValidator.validate(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  /// Valida longitud mínima de contraseña
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < minLength) {
      return 'La contraseña debe tener al menos $minLength caracteres';
    }
    return null;
  }

  /// Valida que dos contraseñas coincidan
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Valida formato de teléfono venezolano
  static String? phoneVenezuela(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opcional
    }

    // Eliminar espacios y guiones
    final cleanValue = value.replaceAll(RegExp(r'[\s\-]'), '');

    // Validar formato: +58XXXXXXXXXX o 0XXXXXXXXXX
    final phoneRegex = RegExp(r'^(\+58|0)(4(12|14|24|16|26))\d{7}$');

    if (!phoneRegex.hasMatch(cleanValue)) {
      return 'Ingresa un teléfono válido (ej: 0412-1234567)';
    }
    return null;
  }

  /// Valida cédula venezolana
  static String? cedulaVenezuela(String? value) {
    if (value == null || value.isEmpty) {
      return 'La cédula es requerida';
    }

    // Eliminar espacios, guiones y puntos
    final cleanValue = value.replaceAll(RegExp(r'[\s\-\.]'), '');

    // Validar formato: V12345678 o E12345678 o J12345678
    final cedulaRegex = RegExp(r'^[VEJ]\d{7,9}$', caseSensitive: false);

    if (!cedulaRegex.hasMatch(cleanValue.toUpperCase())) {
      return 'Ingresa una cédula válida (ej: V-12345678)';
    }
    return null;
  }

  /// Valida número de referencia bancaria
  static String? referenceNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de referencia es requerido';
    }

    // Validar que contenga solo números y tenga entre 6 y 20 dígitos
    final referenceRegex = RegExp(r'^\d{6,20}$');

    if (!referenceRegex.hasMatch(value)) {
      return 'Ingresa un número de referencia válido (solo números)';
    }
    return null;
  }

  /// Valida que un valor numérico esté en un rango
  static String? numberInRange(
    String? value, {
    required double min,
    required double max,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Ingresa un número válido';
    }

    if (number < min || number > max) {
      return '${fieldName ?? 'El valor'} debe estar entre $min y $max';
    }
    return null;
  }

  /// Valida peso (kg)
  static String? weight(String? value) {
    return numberInRange(
      value,
      min: 30,
      max: 300,
      fieldName: 'El peso',
    );
  }

  /// Valida altura (cm)
  static String? height(String? value) {
    return numberInRange(
      value,
      min: 100,
      max: 250,
      fieldName: 'La altura',
    );
  }

  /// Valida edad
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'La edad es requerida';
    }

    final ageNumber = int.tryParse(value);
    if (ageNumber == null) {
      return 'Ingresa una edad válida';
    }

    if (ageNumber < 13 || ageNumber > 120) {
      return 'Debes tener entre 13 y 120 años';
    }
    return null;
  }

  /// Valida nombre (solo letras y espacios)
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }

    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    final nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'El nombre solo puede contener letras';
    }
    return null;
  }

  /// Valida monto de pago
  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'El monto es requerido';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Ingresa un monto válido';
    }

    if (amount <= 0) {
      return 'El monto debe ser mayor a 0';
    }

    if (amount > 1000000) {
      return 'El monto es demasiado alto';
    }
    return null;
  }

  /// Valida URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opcional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida';
    }
    return null;
  }

  /// Combina múltiples validadores
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}
