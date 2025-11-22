# Registro de Restauración y Cambios Recientes
**Fecha:** 21 de Noviembre de 2025
**Estado:** En proceso de estabilización y corrección de errores.

Este documento resume los cambios críticos realizados recientemente para facilitar una restauración en caso de errores críticos.

## 1. Integración de Stripe (Pagos)
- **Dependencias:** Se agregó `flutter_stripe: ^10.1.1` al `pubspec.yaml`.
- **Configuración Android:** Se actualizó `android/app/build.gradle.kts` cambiando `minSdk` a `21` (requerido por Stripe).
- **Servicio:** Se creó `lib/services/stripe_service.dart` para manejar la lógica del cliente (PaymentSheet).
- **Backend (Supabase Edge Function):**
  - Se creó `supabase/functions/payment-sheet/index.ts` con código TypeScript para generar `PaymentIntent`.
  - **Acción requerida:** El usuario debe desplegar esta función con `supabase functions deploy payment-sheet`.
- **Seguridad:**
  - Se actualizó `.gitignore` para asegurar `lib/config/api_keys.dart`.
  - Se modificó `lib/config/api_keys.dart` para incluir `stripePublishableKey`.

## 2. Flujo de Onboarding
- **Lógica de "Una sola vez":** Se modificó `lib/navigation/app_routes.dart` para verificar `SharedPreferences` y redirigir a Login o Home según corresponda.
- **Post-Registro:** Se creó `lib/screens/onboarding/post_registration_onboarding_screen.dart`.
  - **Pasos:** Motivación -> Visualización -> Compromiso -> Resumen.
  - **Diseño:** UI oscura con acentos naranjas, selección de tarjetas.

## 3. Pantalla de Suscripción
- **Archivo:** `lib/screens/membership/subscription_plans_screen.dart`.
- **Características:**
  - Planes: Mensual, Trimestral, Anual (Destacado).
  - Integración con `StripeService` para procesar pagos.
  - UI con gradientes y efectos de "brillo" para el plan recomendado.

## 4. Rediseño de Perfil (Estilo Social)
- **Archivo:** `lib/screens/profile/profile_screen.dart`.
- **Cambios:**
  - Cabecera con avatar grande y botón de edición.
  - Fila de estadísticas (Racha, Nivel, Seguidores).
  - Tarjeta de IMC rediseñada y gráfico de progreso.
  - Navegación a `EditProfileScreen` movida al icono de configuración (tuerca).

## 5. Archivos Clave Modificados
- `lib/navigation/app_routes.dart`
- `lib/screens/profile/profile_screen.dart`
- `lib/services/stripe_service.dart`
- `lib/screens/onboarding/post_registration_onboarding_screen.dart`
- `android/app/build.gradle.kts`
- `pubspec.yaml`

---
**Nota:** Si se requiere restaurar, se pueden revertir los cambios en estos archivos específicos usando el historial de git o copias de seguridad locales.
