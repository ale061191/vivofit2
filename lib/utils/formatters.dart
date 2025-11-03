import 'package:intl/intl.dart';

/// Formateadores de datos para la aplicación
class Formatters {
  /// Formatea un número a moneda (USD)
  static String currency(double value, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Formatea un número a moneda venezolana (Bs)
  static String currencyVenezuela(double value) {
    final formatter = NumberFormat.currency(
      locale: 'es_VE',
      symbol: 'Bs ',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Formatea una fecha a formato legible
  static String date(DateTime date, {String format = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(format, 'es');
    return formatter.format(date);
  }

  /// Formatea una fecha con hora
  static String dateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm', 'es');
    return formatter.format(dateTime);
  }

  /// Formatea una fecha de forma relativa (hace 2 días, etc.)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Hace $years ${years == 1 ? 'año' : 'años'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'Ahora mismo';
    }
  }

  /// Formatea un teléfono venezolano
  static String phoneVenezuela(String phone) {
    // Eliminar caracteres no numéricos
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.length == 11 && cleaned.startsWith('0')) {
      // Formato: 0412-1234567
      return '${cleaned.substring(0, 4)}-${cleaned.substring(4)}';
    } else if (cleaned.length == 12 && cleaned.startsWith('58')) {
      // Formato: +58 412-1234567
      return '+${cleaned.substring(0, 2)} ${cleaned.substring(2, 5)}-${cleaned.substring(5)}';
    }
    
    return phone;
  }

  /// Formatea una cédula venezolana
  static String cedulaVenezuela(String cedula) {
    // Eliminar caracteres no alfanuméricos
    final cleaned = cedula.replaceAll(RegExp(r'[^\dVEJvej]'), '');
    
    if (cleaned.length > 1) {
      final letter = cleaned[0].toUpperCase();
      final numbers = cleaned.substring(1);
      
      // Agregar puntos cada 3 dígitos
      final formatted = numbers.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
      
      return '$letter-$formatted';
    }
    
    return cedula;
  }

  /// Formatea un número grande con separadores de miles
  static String number(num value, {int decimals = 0}) {
    final formatter = NumberFormat.decimalPattern('es');
    if (decimals > 0) {
      return value.toStringAsFixed(decimals);
    }
    return formatter.format(value);
  }

  /// Formatea duración en minutos a formato legible
  static String duration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    
    if (mins == 0) {
      return '$hours ${hours == 1 ? 'hora' : 'horas'}';
    }
    
    return '$hours ${hours == 1 ? 'hora' : 'horas'} $mins min';
  }

  /// Formatea calorías
  static String calories(int calories) {
    if (calories < 1000) {
      return '$calories kcal';
    }
    
    final k = (calories / 1000).toStringAsFixed(1);
    return '$k k kcal';
  }

  /// Formatea peso
  static String weight(double kg) {
    return '${kg.toStringAsFixed(1)} kg';
  }

  /// Formatea altura
  static String height(double cm) {
    final meters = (cm / 100).toStringAsFixed(2);
    return '$meters m';
  }

  /// Formatea IMC
  static String imc(double value) {
    return value.toStringAsFixed(1);
  }

  /// Formatea porcentaje
  static String percentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  /// Capitaliza primera letra de cada palabra
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Trunca texto con elipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Formatea número de referencia bancaria
  static String referenceNumber(String reference) {
    // Agregar espacios cada 4 dígitos para legibilidad
    return reference.replaceAllMapped(
      RegExp(r'(\d{4})(?=\d)'),
      (Match m) => '${m[1]} ',
    );
  }

  /// Formatea tiempo de lectura
  static String readTime(int minutes) {
    if (minutes <= 1) return '1 min de lectura';
    return '$minutes min de lectura';
  }

  /// Formatea rating con estrellas
  static String rating(double rating) {
    return '${rating.toStringAsFixed(1)} ⭐';
  }

  /// Limpia y normaliza texto para búsquedas
  static String normalizeForSearch(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll('ñ', 'n')
        .trim();
  }

  /// Valida y formatea URL
  static String? validateUrl(String url) {
    if (url.isEmpty) return null;
    
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    
    return url;
  }

  /// Formatea nombre de archivo
  static String fileName(String name, String extension) {
    final cleanName = name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${cleanName}_$timestamp.$extension';
  }
}
