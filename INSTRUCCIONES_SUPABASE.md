# 🗄️ INSTRUCCIONES: Crear Base de Datos en Supabase

## Paso 1: Acceder al SQL Editor de Supabase

1. Ve a tu proyecto en Supabase: https://app.supabase.com
2. En el menú lateral izquierdo, haz clic en **"SQL Editor"**
3. Haz clic en **"New query"** (botón verde)

## Paso 2: Copiar y Ejecutar el SQL

1. Abre el archivo `supabase_schema.sql` (en la raíz del proyecto)
2. **Copia TODO el contenido** del archivo
3. **Pega** el contenido en el editor SQL de Supabase
4. Haz clic en el botón **"Run"** (o presiona `Ctrl+Enter` / `Cmd+Enter`)

## Paso 3: Verificar que las Tablas se Crearon

1. En el menú lateral, ve a **"Table Editor"**
2. Deberías ver 5 tablas:
   - ✅ `users`
   - ✅ `workout_sessions`
   - ✅ `nutritional_analyses`
   - ✅ `bmi_history`
   - ✅ `memberships`

## Paso 4: Configurar Storage para Imágenes (Opcional pero recomendado)

### Para fotos de perfil:

1. Ve a **"Storage"** en el menú lateral
2. Haz clic en **"Create bucket"**
3. Nombre: `profile-photos`
4. Marca como **"Public bucket"** (para que las fotos sean accesibles)
5. Haz clic en **"Create bucket"**

### Para fotos de comida (análisis nutricional):

1. Crea otro bucket
2. Nombre: `food-photos`
3. Marca como **"Public bucket"**
4. Haz clic en **"Create bucket"**

## Paso 5: Verificar Row Level Security (RLS)

Las políticas de seguridad ya están configuradas en el SQL. Para verificar:

1. Ve a **"Authentication"** > **"Policies"**
2. Verifica que cada tabla tenga políticas activas
3. Las políticas aseguran que los usuarios solo puedan ver/editar SUS propios datos

## 📊 Estructura de la Base de Datos

### Tabla: `users`
- Almacena información de perfil de usuarios
- Incluye: email, nombre, altura, peso, edad, foto, etc.

### Tabla: `workout_sessions`
- Registro de entrenamientos completados
- Incluye: programa, rutina, duración, calorías, fecha

### Tabla: `nutritional_analyses`
- Análisis de comidas con IA (Gemini)
- Incluye: nombre, calorías, macros, beneficios, foto

### Tabla: `bmi_history`
- Historial de mediciones de IMC
- Permite ver evolución del peso y IMC en el tiempo

### Tabla: `memberships`
- Membresías premium de usuarios
- Incluye: tipo, estado, fechas, datos de pago

## 🔐 Seguridad

- ✅ **Row Level Security (RLS)** habilitado en todas las tablas
- ✅ Los usuarios solo pueden ver/editar sus propios datos
- ✅ Las políticas están configuradas automáticamente
- ✅ La autenticación de Supabase maneja la seguridad

## ⚠️ Notas Importantes

1. **NO compartas** tu Service Role Key (solo usa el Anon Key)
2. El Anon Key ya está configurado en `lib/config/supabase_config.dart`
3. Las credenciales deben eliminarse antes de entregar al cliente
4. Supabase tiene límites en el plan gratuito:
   - 500 MB de base de datos
   - 1 GB de almacenamiento
   - 2 GB de transferencia mensual

## 🚀 Siguiente Paso

Una vez ejecutado el SQL y verificado que las tablas existen:

1. Avísame para continuar con la integración en Flutter
2. Crearemos los servicios de Supabase
3. Migraremos los datos existentes
4. Actualizaremos todos los servicios para usar Supabase

---

**¿Necesitas ayuda con algún paso?** 🤔
