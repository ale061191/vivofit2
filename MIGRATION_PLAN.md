# 🚀 Plan de Migración a Supabase y Generación de APK

## ⚠️ ADVERTENCIA DE SEGURIDAD

**🔒 NUNCA expongas tus credenciales reales en este archivo.**

- ✅ Este archivo contiene **SOLO ejemplos** y placeholders
- ✅ Las credenciales reales están en `lib/config/api_keys.dart` (protegido por `.gitignore`)
- ❌ **NUNCA** reemplaces los placeholders con claves reales en archivos de documentación
- ❌ **NUNCA** hagas commit de `api_keys.dart` o archivos similares

---

## 📋 Índice
1. [Configuración de Supabase](#1-configuración-de-supabase)
2. [Migración de Datos](#2-migración-de-datos)
3. [Actualización del Código](#3-actualización-del-código)
4. [Testing y Validación](#4-testing-y-validación)
5. [Generación de APK](#5-generación-de-apk)

---

## 1. Configuración de Supabase

### Paso 1.1: Crear Proyecto en Supabase
1. Ve a [supabase.com](https://supabase.com)
2. Crea una cuenta o inicia sesión
3. Crea un nuevo proyecto:
   - Nombre: `vivofit-app`
   - Región: South America (más cercana a Venezuela)
   - Password: (guarda esto de forma segura)

### Paso 1.2: Obtener Credenciales
Desde el Dashboard de tu proyecto:
- **Project URL:** `https://xxxxxxxxxxxxx.supabase.co`
- **Anon Public Key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
- **Service Role Key:** (solo para operaciones admin - NO exponerla)

### Paso 1.3: Agregar Credenciales a la App
Actualizar `lib/config/api_keys.dart`:
```dart
class ApiKeys {
  // Google Gemini API Key
  static const String geminiApiKey = 'TU_GEMINI_API_KEY_AQUI';
  
  // Supabase Configuration
  static const String supabaseUrl = 'https://tu-proyecto.supabase.co';
  static const String supabaseAnonKey = 'tu-clave-publica-aqui';
  
  static bool get isConfigured => 
    geminiApiKey != 'TU_GEMINI_API_KEY_AQUI' && 
    supabaseUrl != 'https://tu-proyecto.supabase.co';
}
```

**⚠️ IMPORTANTE:** Este archivo (`lib/config/api_keys.dart`) está protegido por `.gitignore` y NUNCA debe ser compartido públicamente.

---

## 2. Migración de Datos

### Paso 2.1: Diseño de Base de Datos
Crear las siguientes tablas en Supabase SQL Editor:

```sql
-- Tabla de Usuarios (extiende auth.users de Supabase)
CREATE TABLE public.users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  phone TEXT,
  age INTEGER,
  height NUMERIC(5,2), -- en cm
  weight NUMERIC(5,2), -- en kg
  imc NUMERIC(4,2),
  location TEXT,
  photo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de Membresías
CREATE TABLE public.memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL,
  duration_months INTEGER NOT NULL,
  features JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de Membresías de Usuarios
CREATE TABLE public.user_memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  membership_id UUID REFERENCES public.memberships(id),
  start_date TIMESTAMP WITH TIME ZONE NOT NULL,
  end_date TIMESTAMP WITH TIME ZONE NOT NULL,
  payment_reference TEXT,
  payment_amount NUMERIC(10,2),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de Programas de Entrenamiento
CREATE TABLE public.training_programs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  difficulty TEXT CHECK (difficulty IN ('Principiante', 'Intermedio', 'Avanzado')),
  duration_weeks INTEGER,
  image_url TEXT,
  is_premium BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de Rutinas
CREATE TABLE public.routines (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_id UUID REFERENCES public.training_programs(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  duration_minutes INTEGER,
  difficulty TEXT,
  image_url TEXT,
  video_url TEXT,
  exercises JSONB, -- Array de ejercicios
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de Sesiones de Entrenamiento (Analytics)
CREATE TABLE public.workout_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  program_id UUID REFERENCES public.training_programs(id),
  routine_id UUID REFERENCES public.routines(id),
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL,
  duration_minutes INTEGER NOT NULL,
  calories_burned INTEGER,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de Alimentos/Comidas
CREATE TABLE public.foods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  image_url TEXT,
  portion_size TEXT,
  calories INTEGER,
  protein NUMERIC(6,2),
  carbs NUMERIC(6,2),
  fats NUMERIC(6,2),
  fiber NUMERIC(6,2),
  nutrients JSONB,
  health_level TEXT CHECK (health_level IN ('bajo', 'medio', 'alto')),
  benefits TEXT[],
  recommendations TEXT,
  suitable_for TEXT[], -- ['vegetarianos', 'veganos', etc]
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de Artículos del Blog
CREATE TABLE public.blog_articles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  excerpt TEXT,
  content TEXT NOT NULL,
  author TEXT,
  category TEXT,
  image_url TEXT,
  read_time INTEGER, -- en minutos
  is_premium BOOLEAN DEFAULT false,
  published_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para mejor performance
CREATE INDEX idx_workout_sessions_user ON public.workout_sessions(user_id);
CREATE INDEX idx_workout_sessions_completed ON public.workout_sessions(completed_at);
CREATE INDEX idx_user_memberships_user ON public.user_memberships(user_id);
CREATE INDEX idx_user_memberships_active ON public.user_memberships(is_active);
CREATE INDEX idx_foods_user ON public.foods(user_id);

-- Habilitar Row Level Security (RLS)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.foods ENABLE ROW LEVEL SECURITY;

-- Políticas de RLS (los usuarios solo pueden ver/editar sus propios datos)
CREATE POLICY "Users can view own data" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own data" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own memberships" ON public.user_memberships
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can view own workouts" ON public.workout_sessions
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own foods" ON public.foods
  FOR ALL USING (auth.uid() = user_id);
```

### Paso 2.2: Insertar Datos Iniciales
```sql
-- Membresías predefinidas
INSERT INTO public.memberships (name, description, price, duration_months, features) VALUES
('Básica', 'Acceso a programas básicos', 9.99, 1, '["Programas básicos", "Rutinas guiadas", "Seguimiento de progreso"]'),
('Premium', 'Acceso completo', 19.99, 1, '["Todos los programas", "Nutrición personalizada", "Análisis con IA", "Blog completo"]'),
('Anual', 'Mejor valor - 12 meses', 199.99, 12, '["Todos los beneficios Premium", "3 meses gratis", "Soporte prioritario"]');

-- Programas de ejemplo
INSERT INTO public.training_programs (title, description, difficulty, duration_weeks, is_premium) VALUES
('Cuerpo Completo', 'Entrenamiento integral para todos los músculos', 'Principiante', 8, false),
('Fuerza Avanzada', 'Programa intensivo de fuerza', 'Avanzado', 12, true),
('Definición Muscular', 'Tonifica y define tu cuerpo', 'Intermedio', 10, true);
```

---

## 3. Actualización del Código

### Paso 3.1: Agregar Dependencias
Actualizar `pubspec.yaml`:
```yaml
dependencies:
  supabase_flutter: ^2.3.0
  # Las demás dependencias existentes...
```

### Paso 3.2: Inicializar Supabase
Actualizar `lib/main.dart`:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await Supabase.initialize(
    url: ApiKeys.supabaseUrl,
    anonKey: ApiKeys.supabaseAnonKey,
  );
  
  // SharedPreferences para caché local (mantener)
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<Supabase>(create: (_) => Supabase.instance),
        ChangeNotifierProvider(create: (_) => AuthService()),
        // ... otros providers
      ],
      child: const VivoFitApp(),
    ),
  );
}
```

### Paso 3.3: Crear Servicio de Supabase
Crear `lib/services/supabase_service.dart`:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;
  
  // Auth helpers
  static User? get currentUser => client.auth.currentUser;
  static bool get isAuthenticated => currentUser != null;
  
  // Database helpers
  static SupabaseQueryBuilder get users => client.from('users');
  static SupabaseQueryBuilder get memberships => client.from('memberships');
  static SupabaseQueryBuilder get userMemberships => client.from('user_memberships');
  static SupabaseQueryBuilder get workoutSessions => client.from('workout_sessions');
  static SupabaseQueryBuilder get foods => client.from('foods');
  static SupabaseQueryBuilder get programs => client.from('training_programs');
  static SupabaseQueryBuilder get routines => client.from('routines');
  static SupabaseQueryBuilder get articles => client.from('blog_articles');
}
```

### Paso 3.4: Migrar AuthService
Actualizar `lib/services/auth_service.dart` para usar Supabase Auth

### Paso 3.5: Migrar WorkoutTrackerService
Actualizar para usar Supabase en lugar de SharedPreferences

---

## 4. Testing y Validación

### Paso 4.1: Testing Local
- [ ] Autenticación (login/registro)
- [ ] Perfil de usuario (ver/editar)
- [ ] Programas y rutinas
- [ ] Analytics de entrenamiento
- [ ] Sistema de membresías
- [ ] Análisis nutricional

### Paso 4.2: Testing en Chrome
```bash
flutter run -d chrome
```

### Paso 4.3: Testing en Android Emulador
```bash
flutter emulators --launch <emulator-id>
flutter run
```

---

## 5. Generación de APK

### Paso 5.1: Configurar Keystore (Firma de la App)
```bash
# Generar keystore
keytool -genkey -v -keystore c:\Users\Usuario\vivofit-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias vivofit

# Información a proporcionar:
# - Password del keystore (GUARDAR SEGURO)
# - Nombre, organización, ciudad, país
# - Password del alias (puede ser el mismo)
```

### Paso 5.2: Configurar Gradle
Crear `android/key.properties`:
```properties
storePassword=tu_password_aqui
keyPassword=tu_password_aqui
keyAlias=vivofit
storeFile=c:\\Users\\Usuario\\vivofit-keystore.jks
```

Actualizar `android/app/build.gradle`:
```gradle
// Antes de android {
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... configuración existente
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### Paso 5.3: Configurar Metadatos de la App
Actualizar `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    
    <application
        android:label="VivoFit"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- ... resto de configuración -->
    </application>
</manifest>
```

### Paso 5.4: Generar APK Release
```bash
# Limpiar build anterior
flutter clean

# Obtener dependencias
flutter pub get

# Generar APK
flutter build apk --release

# O generar APK por ABI (tamaño más pequeño)
flutter build apk --split-per-abi --release
```

**Ubicación del APK generado:**
- `build/app/outputs/flutter-apk/app-release.apk`
- O con split-per-abi: `app-armeabi-v7a-release.apk`, `app-arm64-v8a-release.apk`

### Paso 5.5: Instalar en tu Smartphone
```bash
# Opción 1: Usando ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# Opción 2: Manual
# 1. Copia el APK a tu teléfono
# 2. Abre el archivo desde el administrador de archivos
# 3. Habilita "Instalar apps de fuentes desconocidas" si es necesario
# 4. Instala la app
```

---

## 📊 Cronograma Estimado

| Fase | Tiempo Estimado | Prioridad |
|------|----------------|-----------|
| Configurar Supabase | 1-2 horas | Alta |
| Crear esquema de BD | 2-3 horas | Alta |
| Migrar AuthService | 2-3 horas | Alta |
| Migrar WorkoutTracker | 2-3 horas | Media |
| Testing completo | 2-4 horas | Alta |
| Configurar firma APK | 1 hora | Media |
| Generar y probar APK | 1 hora | Alta |
| **TOTAL** | **11-17 horas** | - |

---

## ✅ Checklist de Migración

### Configuración Inicial
- [ ] Crear proyecto en Supabase
- [ ] Configurar credenciales en api_keys.dart
- [ ] Agregar supabase_flutter a pubspec.yaml
- [ ] Inicializar Supabase en main.dart

### Base de Datos
- [ ] Crear todas las tablas
- [ ] Configurar índices
- [ ] Habilitar RLS
- [ ] Crear políticas de seguridad
- [ ] Insertar datos iniciales

### Servicios
- [ ] Migrar AuthService
- [ ] Migrar UserService
- [ ] Migrar WorkoutTrackerService
- [ ] Crear servicio de Membresías
- [ ] Crear servicio de Alimentos
- [ ] Crear servicio de Blog

### Testing
- [ ] Login/Registro funciona
- [ ] Perfil se carga correctamente
- [ ] Analytics funcionan
- [ ] Membresías se validan
- [ ] Imágenes se cargan

### APK
- [ ] Generar keystore
- [ ] Configurar firma
- [ ] Actualizar metadatos
- [ ] Generar APK release
- [ ] Probar en smartphone físico

---

## 🎯 Próximos Pasos Inmediatos

1. **Confirma** si quieres empezar con la migración a Supabase
2. **Decide** si prefieres hacerlo paso a paso (servicio por servicio) o completo
3. Te guío en la creación del proyecto de Supabase
4. Creamos juntos el esquema de base de datos
5. Migramos los servicios uno por uno
6. Generamos el APK para probar

**¿Por dónde quieres empezar?** 🚀
