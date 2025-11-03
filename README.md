# 🏋️ Vivofit - Aplicación Móvil Fitness

[![Flutter](https://img.shields.io/badge/Flutter-3.2+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.2+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Vivofit** es una aplicación móvil de fitness completa que permite a los usuarios registrarse, gestionar su perfil de salud, adquirir rutinas online y acceder a contenido premium sobre entrenamiento y nutrición.

## 📋 Características Principales

### 🎨 Diseño UI/UX
- **Paleta de colores**: Fondo negro (#161616), naranja brillante (#FF9900) para acentos
- **Tipografía**: Google Fonts (Inter) moderna y legible
- **Navegación**: Bottom Navigation Bar con 4 secciones principales
- **Componentes**: Cards redondeados, espaciado generoso, diseño touch-friendly

### 🔐 Autenticación
- Registro y login con email/contraseña
- Recuperación de contraseña
- Gestión de sesiones con Provider

### 🏠 Pantallas Principales

#### Home
- Listado de programas de entrenamiento con duración, calificación y precio
- Rutinas segmentadas por grupo muscular
- Cards visuales con restricción de acceso premium
- Filtros por músculo (pecho, espalda, piernas, brazos, hombros, core)

#### Nutrición
- Buscador de alimentos con filtros
- Categorías: desayuno, almuerzo, cena, merienda
- Detalles de preparación, calorías e información nutricional
- Macronutrientes detallados (proteínas, carbohidratos, grasas)

#### Blog
- Artículos sobre fitness, nutrición y bienestar
- Filtros por tema
- Tiempo de lectura estimado
- Vista detallada con contenido enriquecido

#### Perfil
- Visualización y edición de datos personales
- **Cálculo automático de IMC** en base a altura y peso
- Gestión de foto de perfil
- Listado de membresías activas
- Cierre de sesión

### 💳 Sistema de Membresías y Pagos
- Activación de programas premium
- **Formulario de pago móvil adaptado a Venezuela**
  - Selección de banco
  - Teléfono, cédula y monto
  - Número de referencia bancaria
- Validación de datos con formato venezolano
- Confirmación de pago pendiente de verificación

### 🔒 Contenido Premium
- Restricción de acceso a videos/rutinas
- Overlay visual para contenido bloqueado
- Indicadores claros de contenido premium
- Botones de desbloqueo integrados

## 🏗️ Arquitectura del Proyecto

```
lib/
├── components/          # Componentes reutilizables
│   ├── bottom_nav_bar.dart
│   ├── custom_button.dart
│   ├── custom_cards.dart
│   └── common_widgets.dart
├── models/             # Modelos de datos
│   ├── user.dart
│   ├── program.dart
│   ├── routine.dart
│   ├── food.dart
│   ├── article.dart
│   └── membership.dart
├── screens/            # Pantallas de la app
│   ├── onboarding_screen.dart
│   ├── main_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── program_detail_screen.dart
│   │   └── routine_detail_screen.dart
│   ├── nutrition/
│   │   ├── nutrition_screen.dart
│   │   └── food_detail_screen.dart
│   ├── blog/
│   │   ├── blog_screen.dart
│   │   └── article_detail_screen.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   └── edit_profile_screen.dart
│   ├── membership/
│   │   └── activate_membership_screen.dart
│   └── payment/
│       └── payment_screen.dart
├── services/           # Lógica de negocio
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── user_service.dart
├── utils/              # Utilidades
│   ├── imc_calculator.dart
│   ├── validators.dart
│   └── formatters.dart
├── theme/              # Estilos globales
│   ├── app_theme.dart
│   └── color_palette.dart
├── navigation/         # Rutas y navegación
│   └── app_routes.dart
└── main.dart          # Punto de entrada
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK 3.2+ ([Instalar Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK 3.2+
- Android Studio o Xcode (según plataforma)
- Editor de código (VS Code recomendado con extensiones de Flutter)

### Paso 1: Clonar o configurar el proyecto

```powershell
# Si usas Git
git clone <tu-repositorio>
cd vivoFit

# O simplemente navega al directorio del proyecto
cd c:\Users\Usuario\Documents\vivoFit
```

### Paso 2: Instalar dependencias

```powershell
flutter pub get
```

### Paso 3: Verificar configuración

```powershell
flutter doctor
```

### Paso 4: Ejecutar la aplicación

```powershell
# Para Android
flutter run

# Para iOS (requiere Mac)
flutter run

# Para Web
flutter run -d chrome

# Para Windows
flutter run -d windows
```

## 📦 Dependencias Principales

### State Management
- `provider: ^6.1.1` - Gestión de estado reactivo

### Navegación
- `go_router: ^13.0.0` - Navegación declarativa

### UI/UX
- `google_fonts: ^6.1.0` - Fuentes modernas
- `flutter_svg: ^2.0.9` - Soporte para SVG
- `cached_network_image: ^3.3.1` - Caché de imágenes

### Forms & Validation
- `email_validator: ^2.1.17` - Validación de emails
- `mask_text_input_formatter: ^2.7.0` - Máscaras de entrada

### Date & Time
- `table_calendar: ^3.0.9` - Calendario interactivo
- `intl: ^0.19.0` - Internacionalización

### Media
- `image_picker: ^1.0.7` - Selección de imágenes
- `video_player: ^2.8.2` - Reproducción de videos
- `chewie: ^1.7.5` - Player de video mejorado

### Networking
- `http: ^1.2.0` - Peticiones HTTP

### Storage
- `shared_preferences: ^2.2.2` - Almacenamiento local

## 🎯 Flujos de Negocio Implementados

### 1. Autenticación
```dart
// Login con credenciales demo
Email: demo@vivofit.com
Password: 123456
```

### 2. Cálculo de IMC
```dart
// El perfil calcula automáticamente el IMC
IMC = peso(kg) / altura(m)²

// Categorías implementadas:
// - Bajo peso (< 18.5)
// - Peso normal (18.5 - 24.9)
// - Sobrepeso (25 - 29.9)
// - Obesidad (≥ 30)
```

### 3. Control de Acceso Premium
```dart
// Verificación de membresía
bool hasMembership(String programId) {
  return user.activeMemberships.contains(programId);
}

// Rutinas bloqueadas muestran overlay con botón de desbloqueo
```

### 4. Validación de Pagos (Venezuela)
```dart
// Formatos soportados:
Teléfono: 0412-1234567
Cédula: V-12345678
Referencia: Solo números (6-20 dígitos)
```

## 🎨 Personalización de Tema

### Colores
Edita `lib/theme/color_palette.dart`:

```dart
static const Color background = Color(0xFF161616);  // Fondo negro
static const Color primary = Color(0xFFFF9900);     // Naranja brillante
static const Color textPrimary = Color(0xFFFFFFFF); // Blanco
static const Color textSecondary = Color(0xFFB0B0B0); // Gris claro
```

### Tipografía
Edita `lib/theme/app_theme.dart`:

```dart
textTheme: GoogleFonts.interTextTheme(...)
```

Cambia `inter` por cualquier fuente de Google Fonts.

## 🌐 Internacionalización (i18n)

### Preparación para múltiples idiomas

1. **Agregar paquetes**:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

2. **Crear archivos de traducción**:
```
lib/
└── l10n/
    ├── app_es.arb  # Español
    ├── app_en.arb  # Inglés
    └── app_pt.arb  # Portugués
```

3. **Configurar en `main.dart`**:
```dart
MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('es', 'VE'), // Español Venezuela
    Locale('en', 'US'), // Inglés
  ],
  // ...
)
```

## 🌓 Soporte para Tema Claro

El proyecto está preparado para implementar tema claro:

```dart
// En app_theme.dart ya existe:
static ThemeData get lightTheme {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: ColorPalette.primary,
    // TODO: Completar implementación
  );
}
```

Para activarlo, usa un `ChangeNotifier` que alterne entre temas.

## 🔧 Integración con Backend

### Configurar API
Edita `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'https://tu-api.com/v1';
```

### Endpoints implementados

```dart
// Autenticación
POST /auth/login
POST /auth/register
POST /auth/reset-password

// Usuario
GET /users/:id
PUT /users/:id

// Programas
GET /programs
GET /programs/:id

// Rutinas
GET /routines
GET /routines/:id

// Alimentos
GET /foods
GET /foods/:id

// Artículos
GET /articles
GET /articles/:id

// Membresías
GET /users/:id/memberships
POST /users/:id/memberships

// Pagos
POST /payments
GET /users/:id/payments
```

## 🧪 Testing

### Datos Mockeados
El proyecto incluye datos de prueba en cada modelo:

```dart
// Usar datos mock
final users = [User.mock()];
final programs = Program.mockList();
final routines = Routine.mockList();
final foods = Food.mockList();
final articles = Article.mockList();
```

### Credenciales Demo
```
Email: demo@vivofit.com
Password: 123456
```

## 📱 Compilación para Producción

### Android
```powershell
flutter build apk --release
# APK en: build\app\outputs\flutter-apk\app-release.apk

# O Bundle (recomendado para Play Store)
flutter build appbundle --release
```

### iOS
```powershell
flutter build ios --release
```

### Web
```powershell
flutter build web --release
```

## 🚀 Escalabilidad y Mejores Prácticas

### Patrones Implementados
- **Provider Pattern**: Gestión de estado centralizada
- **Repository Pattern**: Preparado para `api_service.dart`
- **Service Layer**: Separación de lógica de negocio
- **Component Reusability**: Componentes modulares y reutilizables

### Próximos Pasos Recomendados

1. **Implementar BLoC o Riverpod** para state management más robusto
2. **Añadir tests unitarios** para servicios y utilidades
3. **Implementar persistencia** con Hive o SQLite
4. **Añadir Analytics** (Firebase Analytics)
5. **Implementar Push Notifications** (Firebase Cloud Messaging)
6. **Añadir Crash Reporting** (Firebase Crashlytics)
7. **Implementar CI/CD** con GitHub Actions
8. **Optimizar imágenes** con loading placeholders
9. **Añadir animaciones** con AnimatedWidgets
10. **Implementar deep linking** con go_router

### Estructura para Escalar

```dart
lib/
├── data/
│   ├── repositories/    # Acceso a datos
│   ├── datasources/     # API y local storage
│   └── models/          # DTOs y entities
├── domain/
│   ├── entities/        # Modelos de dominio
│   └── usecases/        # Casos de uso
└── presentation/
    ├── blocs/           # Lógica de presentación
    ├── pages/           # Pantallas
    └── widgets/         # Componentes UI
```

## 📝 TODOs Pendientes

- [ ] Implementar video player en `RoutineDetailScreen`
- [ ] Completar `EditProfileScreen` con formularios
- [ ] Implementar `ActivateMembershipScreen` con calendario
- [ ] Añadir pantalla de detalle completo para programas
- [ ] Implementar pantalla admin para gestión de pedidos
- [ ] Agregar notificaciones push
- [ ] Implementar chat de soporte
- [ ] Añadir modo offline con caché
- [ ] Implementar sistema de logros y badges
- [ ] Agregar gráficos de progreso

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más información.

## 👨‍💻 Autor

**Vivofit Team**

## 📞 Soporte

Para soporte o consultas:
- Email: soporte@vivofit.com
- Website: https://vivofit.com

---

⭐ **¡Dale una estrella si este proyecto te fue útil!**

🏋️ **¡Transforma tu vida con Vivofit!**
