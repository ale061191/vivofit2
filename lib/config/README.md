# 🔐 Configuración de API Keys

## ⚠️ IMPORTANTE: Seguridad de Credenciales

Este directorio contiene archivos de configuración para claves API sensibles.

### Archivos en este directorio:

#### 📄 `api_keys.dart` (PRIVADO - NO SE SUBE A GITHUB)
- Contiene las **claves API reales**
- Protegido por `.gitignore`
- **NUNCA debe subirse a GitHub o repositorios públicos**

#### 📋 `api_keys.example.dart` (PÚBLICO - Template)
- Archivo de ejemplo que SÍ se sube a GitHub
- Muestra la estructura sin exponer credenciales reales
- Los desarrolladores deben copiarlo y configurarlo localmente

#### ⚙️ `gemini_config.dart` (PÚBLICO)
- Configuración de Google Gemini AI
- Lee las claves desde `api_keys.dart`
- No contiene credenciales hardcodeadas

---

## 🚀 Configuración Inicial (Para Desarrolladores)

### Paso 1: Copiar el archivo de ejemplo
```bash
# En Windows PowerShell:
Copy-Item lib/config/api_keys.example.dart lib/config/api_keys.dart

# En Linux/Mac:
cp lib/config/api_keys.example.dart lib/config/api_keys.dart
```

### Paso 2: Obtener tu API Key de Google Gemini
1. Ve a [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Inicia sesión con tu cuenta de Google
3. Crea un nuevo proyecto o selecciona uno existente
4. Genera una nueva API Key
5. **Configura restricciones de API** para mayor seguridad

### Paso 3: Configurar tu clave local
Abre `lib/config/api_keys.dart` y reemplaza `'TU_CLAVE_AQUI'` con tu clave real:

```dart
class ApiKeys {
  static const String geminiApiKey = 'AIzaSy...tu_clave_real_aqui';
  
  static bool get isConfigured => geminiApiKey != 'TU_CLAVE_AQUI';
}
```

### Paso 4: Verificar que funciona
Ejecuta la app y verifica que no hay errores de configuración.

---

## 🛡️ Mejores Prácticas de Seguridad

### ✅ SIEMPRE:
1. Mantén `api_keys.dart` en tu `.gitignore`
2. Usa restricciones de API en Google Cloud Console
3. Regenera claves comprometidas inmediatamente
4. Nunca compartas claves en issues, PRs, o chat
5. Usa variables de entorno en producción

### ❌ NUNCA:
1. Subas `api_keys.dart` a GitHub
2. Hardcodees API keys en código
3. Compartas claves en capturas de pantalla
4. Uses la misma clave para desarrollo y producción
5. Publiques claves en documentación pública

---

## 🔄 Regenerar Claves Comprometidas

Si una clave se expone públicamente:

1. **Inmediatamente** ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Deshabilita o elimina la clave comprometida
3. Genera una nueva API Key
4. Actualiza `lib/config/api_keys.dart` con la nueva clave
5. Verifica que la app funcione correctamente
6. Nunca hagas commit de la nueva clave

---

## 📞 Soporte

Si tienes dudas sobre la configuración de seguridad, consulta:
- [SECURITY.md](../../SECURITY.md) en la raíz del proyecto
- [Documentación de Google Cloud Security](https://cloud.google.com/security/best-practices)

---

**Última actualización:** 5 de Noviembre, 2025
