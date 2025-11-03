import 'package:flutter/material.dart';

/// Paleta de colores global de Vivofit
/// Facilita cambios de estilo centralizados
class ColorPalette {
  // Colores primarios
  static const Color background = Color(0xFF161616); // Negro de fondo
  static const Color primary = Color(0xFFFF9900); // Naranja brillante
  static const Color primaryDark =
      Color(0xFFCC7700); // Naranja oscuro para hover

  // Colores de texto
  static const Color textPrimary = Color(0xFFFFFFFF); // Blanco
  static const Color textSecondary = Color(0xFFB0B0B0); // Gris claro
  static const Color textTertiary = Color(0xFF707070); // Gris medio

  // Colores de superficie
  static const Color cardBackground =
      Color(0xFF1E1E1E); // Gris oscuro para cards
  static const Color cardBackgroundLight =
      Color(0xFF2A2A2A); // Gris claro para cards

  // Colores de estado
  static const Color success = Color(0xFF4CAF50); // Verde
  static const Color error = Color(0xFFFF5252); // Rojo
  static const Color warning = Color(0xFFFFC107); // Amarillo
  static const Color info = Color(0xFF2196F3); // Azul

  // Colores de interacción
  static const Color divider = Color(0xFF2A2A2A);
  static const Color disabled = Color(0xFF404040);
  static const Color overlay = Color(0x88000000); // Negro semi-transparente

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [cardBackground, cardBackgroundLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Degradado para overlays de contenido bloqueado
  static const LinearGradient lockedOverlay = LinearGradient(
    colors: [Color(0xCC161616), Color(0xFF161616)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Métodos de utilidad

  /// Retorna un color con opacidad personalizada
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Retorna el color de acuerdo al tema (preparado para modo claro)
  static Color adaptiveColor(
      BuildContext context, Color darkColor, Color lightColor) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkColor : lightColor;
  }
}
