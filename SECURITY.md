# 🔐 Configuración Segura de API Keys

## ⚠️ IMPORTANTE - Seguridad de Credenciales

Este proyecto utiliza claves API que **NUNCA deben ser compartidas públicamente**.

## 📋 Configuración Inicial

### 1. Configurar Google Gemini API

1. **Copia el archivo de ejemplo:**
   ```bash
   cp lib/config/api_keys.example.dart lib/config/api_keys.dart
   ```

2. **Obtén tu API Key de Google Gemini:**
   - Ve a: https://makersuite.google.com/app/apikey
   - Inicia sesión con tu cuenta de Google
   - Crea un nuevo proyecto o selecciona uno existente
   - Genera una nueva API Key
   - **IMPORTANTE:** Configura restricciones de API

3. **Edita `lib/config/api_keys.dart`:**
   ```dart
   static const String geminiApiKey = 'TU_CLAVE_REAL_AQUI';
   ```

4. **Verifica que `.gitignore` incluye:**
   ```
   lib/config/api_keys.dart
   .env
   ```

## 🛡️ Buenas Prácticas de Seguridad

### ✅ Hacer:
- ✅ Mantener `api_keys.dart` privado (ya está en .gitignore)
- ✅ Configurar restricciones de API en Google Cloud Console
- ✅ Regenerar claves si fueron expuestas accidentalmente
- ✅ Usar claves diferentes para desarrollo y producción
- ✅ Revisar logs de uso de API regularmente

### ❌ NO Hacer:
- ❌ NUNCA subir `api_keys.dart` a GitHub
- ❌ NUNCA compartir claves en chats o correos
- ❌ NUNCA hardcodear claves en código que se sube a repositorios
- ❌ NUNCA usar la misma clave en múltiples proyectos

## 🚨 Si Expusiste una Clave Accidentalmente

1. **Ve inmediatamente a Google Cloud Console**
2. **Regenera la clave comprometida:**
   - Busca "Credenciales" en la consola de Cloud
   - Edita la clave filtrada
   - Usa el botón "Volver a generar clave"
3. **Actualiza tu archivo local `api_keys.dart`**
4. **Revisa la actividad de la API**
5. **Configura restricciones de API**

## 📖 Recursos Adicionales

- [Manejo de credenciales Google Cloud](https://cloud.google.com/docs/authentication/api-keys)
- [Mejores prácticas de seguridad API](https://cloud.google.com/apis/docs/best-practices)
- [Restricciones de API Keys](https://cloud.google.com/docs/authentication/api-keys#api_key_restrictions)

## 🔄 Configuración de Restricciones Recomendadas

En Google Cloud Console, configura:
- **Restricción de aplicación:** HTTP referrers o direcciones IP
- **Restricción de API:** Solo las APIs que uses (Gemini AI)
- **Cuotas:** Límites diarios para prevenir abusos

---

**Nota:** Este archivo SÍ está incluido en el repositorio como documentación. 
Las claves reales están en `api_keys.dart` que está protegido por .gitignore.
