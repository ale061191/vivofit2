import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivofit/theme/color_palette.dart';

class StripeService {
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  // Inicializar Stripe con tu Publishable Key
  void init() {
    // TODO: Reemplazar con tu Publishable Key de Stripe
    Stripe.publishableKey = 'pk_test_TU_CLAVE_PUBLICA_AQUI';
    Stripe.merchantIdentifier = 'merchant.com.vivofit';
    Stripe.instance.applySettings();
  }

  /// Flujo principal de pago
  Future<bool> makePayment(BuildContext context,
      {required String amount, required String currency}) async {
    try {
      // 1. Crear PaymentIntent en el Backend (Supabase Edge Function)
      final paymentData = await _createPaymentIntent(amount, currency);

      if (paymentData == null) return false;

      // 2. Inicializar la hoja de pago (Payment Sheet)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Claves obtenidas del backend
          paymentIntentClientSecret: paymentData['paymentIntent'],
          customerEphemeralKeySecret: paymentData['ephemeralKey'],
          customerId: paymentData['customer'],

          // Configuración visual
          merchantDisplayName: 'Vivofit Premium',
          style: ThemeMode.dark, // Se adapta al tema oscuro de tu app
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: ColorPalette.primary,
              background: ColorPalette.cardBackground,
              componentBackground: ColorPalette.background,
              componentBorder: ColorPalette.textSecondary,
              componentDivider: ColorPalette.textSecondary,
              primaryText: ColorPalette.textPrimary,
              secondaryText: ColorPalette.textSecondary,
              placeholderText: ColorPalette.textTertiary,
              icon: ColorPalette.primary,
            ),
            shapes: PaymentSheetShape(
              borderRadius: 12,
              borderWidth: 1,
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: ColorPalette.primary,
                  text: Colors.black,
                ),
                dark: PaymentSheetPrimaryButtonThemeColors(
                  background: ColorPalette.primary,
                  text: Colors.black,
                ),
              ),
            ),
          ),
        ),
      );

      // 3. Mostrar la hoja de pago
      await Stripe.instance.presentPaymentSheet();

      // 4. Si llegamos aquí, el pago fue exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Pago realizado con éxito! Bienvenido a Premium 🚀'),
          backgroundColor: Colors.green,
        ),
      );
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // El usuario canceló, no mostramos error
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de pago: ${e.error.localizedMessage}'),
          backgroundColor: ColorPalette.error,
        ),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: $e'),
          backgroundColor: ColorPalette.error,
        ),
      );
      return false;
    }
  }

  /// Llama a la Edge Function de Supabase para obtener el Client Secret
  Future<Map<String, dynamic>?> _createPaymentIntent(
      String amount, String currency) async {
    try {
      // Llamada a la Edge Function 'payment-sheet'
      final response = await Supabase.instance.client.functions.invoke(
        'payment-sheet',
        body: {
          'amount': _calculateAmount(amount), // Stripe usa centavos
          'currency': currency,
        },
      );

      if (response.status == 200) {
        return response.data;
      } else {
        debugPrint('Error en Edge Function: ${response.status}');
        return null;
      }
    } catch (e) {
      debugPrint('Error llamando a Supabase: $e');
      // MOCK PARA PRUEBAS (Eliminar en producción)
      // Como no tenemos la Edge Function desplegada aún, esto fallará.
      // Aquí podrías retornar datos mock si tuvieras un backend de prueba local.
      return null;
    }
  }

  String _calculateAmount(String amount) {
    // Convertir string "24.99" a centavos "2499"
    final price = double.parse(amount) * 100;
    return price.toInt().toString();
  }
}
