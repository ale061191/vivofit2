import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivofit/theme/color_palette.dart';

/// Tema de la aplicación Vivofit
/// Centraliza estilos, tipografías y componentes visuales
class AppTheme {
  // Radio de bordes redondeados
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Espaciado
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Elevación (sombras)
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  /// Tema oscuro principal de Vivofit
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorPalette.background,
      primaryColor: ColorPalette.primary,

      // Esquema de colores
      colorScheme: const ColorScheme.dark(
        primary: ColorPalette.primary,
        secondary: ColorPalette.primary,
        surface: ColorPalette.background,
        error: ColorPalette.error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: ColorPalette.textPrimary,
        onError: Colors.white,
      ),

      // Tipografía
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          // Títulos
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: ColorPalette.textPrimary,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: ColorPalette.textPrimary,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorPalette.textPrimary,
          ),
          // Encabezados
          headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: ColorPalette.textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ColorPalette.textPrimary,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorPalette.textPrimary,
          ),
          // Títulos de sección
          titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorPalette.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorPalette.textPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorPalette.textSecondary,
          ),
          // Cuerpo de texto
          bodyLarge: TextStyle(
            fontSize: 16,
            color: ColorPalette.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: ColorPalette.textSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            color: ColorPalette.textTertiary,
          ),
          // Labels
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorPalette.textPrimary,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorPalette.textSecondary,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: ColorPalette.textTertiary,
          ),
        ),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorPalette.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorPalette.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorPalette.textPrimary,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: ColorPalette.cardBackground,
        elevation: elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingSmall,
        ),
      ),

      // Botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primary,
          foregroundColor: Colors.black,
          elevation: elevationMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Botones de texto
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorPalette.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingMedium,
            vertical: paddingSmall,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorPalette.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: ColorPalette.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: ColorPalette.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: ColorPalette.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingMedium,
        ),
        hintStyle: const TextStyle(color: ColorPalette.textTertiary),
        labelStyle: const TextStyle(color: ColorPalette.textSecondary),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorPalette.cardBackground,
        selectedItemColor: ColorPalette.primary,
        unselectedItemColor: ColorPalette.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: elevationHigh,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: ColorPalette.divider,
        thickness: 1,
        space: 1,
      ),

      // Icons
      iconTheme: const IconThemeData(
        color: ColorPalette.textSecondary,
        size: 24,
      ),
    );
  }

  /// Tema claro (preparado para futuras implementaciones)
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: ColorPalette.primary,
      // TODO: Implementar tema claro completo
    );
  }
}
