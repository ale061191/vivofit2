# 🚀 Migración a Supabase - Paso a Paso

## ✅ Estado Actual
- ✅ Supabase configurado e inicializado
- ✅ Base de datos creada con 5 tablas
- ✅ Servicios de Supabase creados y listos
- ✅ Aplicación compilando correctamente

## 📝 Instrucciones de Migración

### Opción Recomendada: Probar Supabase Primero

Antes de migrar todo, vamos a crear **credenciales de prueba en Supabase** para verificar que todo funciona:

### Paso 1: Crear Usuario de Prueba en Supabase Dashboard

1. Ve a tu proyecto en Supabase: https://app.supabase.com
2. En el menú lateral, ve a **"Authentication"** > **"Users"**
3. Haz clic en **"Add user"** > **"Create new user"**
4. Completa los datos:
   - Email: `test@vivofit.com`
   - Password: `123456`
   - Marca **"Auto Confirm User"** (para que no requiera verificación de email)
5. Haz clic en **"Create user"**

### Paso 2: Probar Login con Supabase

Ahora vamos a actualizar **temporalmente** solo la pantalla de login para probar:

#### En `lib/screens/auth/login_screen.dart`:

**Cambiar línea 6:**
```dart
// ANTES:
import 'package:vivofit/services/auth_service.dart';

// DESPUÉS:
import 'package:vivofit/services/supabase_auth_service.dart';
```

**Cambiar línea 7:**
```dart
// ANTES:
import 'package:vivofit/services/user_service.dart';

// DESPUÉS:
import 'package:vivofit/services/supabase_user_service.dart';
```

**Cambiar líneas 36-37:**
```dart
// ANTES:
final authService = context.read<AuthService>();
final userService = context.read<UserService>();

// DESPUÉS:
final authService = context.read<SupabaseAuthService>();
final userService = context.read<SupabaseUserService>();
```

**Cambiar líneas 47-49:**
```dart
// ANTES:
if (authService.currentUser != null) {
  userService.setUser(authService.currentUser!);
}

// DESPUÉS:
await userService.getCurrentUser();
```

**Cambiar línea 171:**
```dart
// ANTES:
Consumer<AuthService>(

// DESPUÉS:
Consumer<SupabaseUserService>(
```

**Cambiar línea 172:**
```dart
// ANTES:
builder: (context, authService, _) {

// DESPUÉS:
builder: (context, userService, _) {
```

**Cambiar línea 176:**
```dart
// ANTES:
isLoading: authService.isLoading,

// DESPUÉS:
isLoading: userService.isLoading,
```

### Paso 3: Actualizar el mensaje demo

**Cambiar líneas 214-225:**
```dart
// ANTES:
const Text(
  'Demo',
  style: TextStyle(
    color: ColorPalette.primary,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 4),
const Text(
  'Email: demo@vivofit.com',
  ...
),
const Text(
  'Password: 123456',
  ...
),

// DESPUÉS:
const Text(
  'Usuario de Prueba',
  style: TextStyle(
    color: ColorPalette.primary,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 4),
const Text(
  'Email: test@vivofit.com',
  style: TextStyle(
    color: ColorPalette.textSecondary,
    fontSize: 12,
  ),
),
const Text(
  'Password: 123456',
  style: TextStyle(
    color: ColorPalette.textSecondary,
    fontSize: 12,
  ),
),
```

### Paso 4: Probar el Login

1. Guarda todos los archivos
2. Ejecuta la aplicación: `flutter run -d chrome`
3. En la pantalla de login, usa:
   - Email: `test@vivofit.com`
   - Password: `123456`
4. Haz clic en "Iniciar Sesión"

### ¿Qué debería pasar?

✅ **Si funciona correctamente:**
- El usuario se autenticará con Supabase
- Se cargará su perfil desde la base de datos
- Navegará a la pantalla principal

❌ **Si hay errores:**
- Revisa la consola para ver el mensaje de error
- Verifica que el usuario fue creado en Supabase
- Verifica que la tabla `users` tiene el registro

---

## 🔄 Siguiente Fase: Migración Completa

Una vez que el login funcione, continuaremos con:

1. **Pantalla de Registro** - Crear usuarios desde la app
2. **Pantalla de Perfil** - Usar SupabaseUserService
3. **Entrenamientos** - Usar SupabaseWorkoutService
4. **Análisis Nutricional** - Crear NutritionalAnalysisService

---

## 💡 Tip: Migración Reversible

Si algo no funciona, simplemente revierte los cambios en `login_screen.dart`:

```bash
git checkout HEAD -- lib/screens/auth/login_screen.dart
```

Y la aplicación volverá a usar el sistema anterior (mock).

---

**¿Listo para probar?** Avísame cuando hayas hecho los cambios y probado el login, o si prefieres que yo haga los cambios directamente. 🚀
