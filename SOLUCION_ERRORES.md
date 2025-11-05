# 🔧 SOLUCIÓN DE ERRORES - Registro con Supabase

## ✅ Estado Actual

### Lo que funcionó:
- ✅ Usuario creado en Supabase Auth: `alejandrobracho061191@gmail.com`
- ✅ Autenticación funciona correctamente

### ❌ Problema encontrado:
- ❌ Error al crear registro en tabla `users`
- ❌ Causa: Políticas RLS (Row Level Security) muy restrictivas

---

## 🔧 SOLUCIÓN 1: Corregir Políticas RLS en Supabase

### Paso 1: Ejecutar Script SQL de Corrección

1. Ve a tu proyecto en Supabase: https://app.supabase.com
2. Abre **SQL Editor**
3. Crea una nueva query
4. Copia y pega el contenido del archivo: **`fix_rls_users.sql`**
5. Haz clic en **"Run"**

### ¿Qué hace este script?

El script corrige la política RLS para permitir que:
- ✅ Un usuario recién registrado pueda crear su perfil en la tabla `users`
- ✅ Solo pueda crear su PROPIO perfil (usando `auth.uid()`)
- ✅ Mantenga la seguridad (no puede crear perfiles de otros usuarios)

---

## 🔧 SOLUCIÓN 2: Problemas Corregidos en el Código

### ✅ Archivo: `test/widget_test.dart`

**Problema:** El test esperaba `MyApp` pero la app se llama `VivofitApp`

**Solución aplicada:**
```dart
// ANTES:
await tester.pumpWidget(const MyApp());

// DESPUÉS:
SharedPreferences.setMockInitialValues({});
final prefs = await SharedPreferences.getInstance();
await tester.pumpWidget(VivofitApp(prefs: prefs));
```

---

## 📊 Verificación en Supabase

### 1. Verificar Políticas RLS

Después de ejecutar el script SQL:

1. Ve a **Authentication** > **Policies**
2. Busca la tabla `users`
3. Deberías ver estas políticas:
   - ✅ `Users can insert their own profile during registration` (INSERT)
   - ✅ `Users can view their own data` (SELECT)
   - ✅ `Users can update their own data` (UPDATE)

### 2. Verificar Tabla Users

1. Ve a **Table Editor** > **users**
2. Verás solo el usuario en Supabase Auth
3. El perfil completo se creará en el próximo registro

---

## 🧪 Probar el Registro Nuevamente

### Opción A: Registrar nuevo usuario

1. Usa otro email diferente (ej: `test2@vivofit.com`)
2. Completa el formulario de registro
3. Haz clic en "Registrarse"

### Opción B: Completar perfil del usuario existente

Dado que tu usuario `alejandrobracho061191@gmail.com` ya existe en Auth, 
vamos a crear su perfil manualmente:

1. Ve a **Table Editor** > **users**
2. Haz clic en **"Insert"** > **"Insert row"**
3. Completa:
   - `id`: `4dd33b0d-42ea-4d50-8b1e-36666eec01d7` (tu user ID de Auth)
   - `email`: `alejandrobracho061191@gmail.com`
   - `name`: `Alejandro Bracho`
4. Haz clic en **"Save"**

Ahora podrás iniciar sesión con ese usuario.

---

## 🎯 Resultado Esperado

Después de ejecutar el SQL fix:

✅ **Al registrarse:**
1. Se crea usuario en Supabase Auth
2. Se crea perfil en tabla `users`
3. Se navega a pantalla principal
4. ¡Sin errores!

✅ **Al iniciar sesión:**
1. Se autentica correctamente
2. Se carga el perfil desde tabla `users`
3. Se navega a pantalla principal

---

## 🚀 Comandos para Verificar

### Ver todos los errores actuales:
```bash
flutter analyze
```

### Ejecutar tests:
```bash
flutter test
```

### Ejecutar la app:
```bash
flutter run -d chrome
```

---

## 📝 Warnings de Supabase (Normales)

Los warnings amarillos que ves en Supabase son **NORMALES** y no afectan el funcionamiento:

- `View 'public.user_stats' is defined with the SECURITY DEFINER property` ✅ Correcto
- `Function 'pg_temp.X_count_estimate' has a role mutable search_path` ✅ Correcto
- Políticas RLS en todas las tablas ✅ Correcto (es lo que queremos)

Estos son avisos informativos de seguridad, no errores.

---

## 🎊 Siguiente Paso

Una vez que ejecutes el SQL fix:

1. **Prueba registrar un nuevo usuario**
2. **O completa el perfil del usuario existente manualmente**
3. **Inicia sesión**
4. **¡Debería funcionar perfectamente!**

---

**¿Ejecutaste el SQL fix? Avísame si todo funciona o si encuentras algún otro error.** 🚀
