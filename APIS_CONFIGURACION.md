# 🔑 CONFIGURACIÓN DE APIS DE ANÁLISIS NUTRICIONAL

Este archivo contiene las instrucciones para configurar las APIs alternativas a Gemini.

## 📋 OPCIONES DISPONIBLES:

### 1. Clarifai (Reconocimiento Visual) ⭐ RECOMENDADO

**Plan Gratuito:** 5,000 operaciones/mes  
**Ventaja:** Reconocimiento visual real de alimentos

#### Pasos para configurar:

1. **Crear cuenta:**
   - Ve a: https://clarifai.com/signup
   - Regístrate con tu email

2. **Obtener API Key:**
   - Ve a: https://clarifai.com/settings/security
   - Click en "Create Personal Access Token"
   - Copia el token generado

3. **Configurar en la app:**
   - Abre: `lib/services/clarifai_service.dart`
   - Línea 11: `static const String _apiKey = 'TU_CLARIFAI_API_KEY_AQUI';`
   - Reemplaza `TU_CLARIFAI_API_KEY_AQUI` con tu token

#### Ejemplo:
```dart
static const String _apiKey = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';
```

---

### 2. Edamam (Base de Datos Nutricional)

**Plan Gratuito:** 1,000 requests/mes  
**Ventaja:** Datos nutricionales muy precisos

#### Pasos para configurar:

1. **Crear cuenta:**
   - Ve a: https://developer.edamam.com/edamam-recipe-api
   - Click en "Sign Up"

2. **Obtener credenciales:**
   - Dashboard → "Applications"
   - Copia tu "Application ID" y "Application Key"

3. **Configurar en la app:**
   - Abre: `lib/services/edamam_service.dart`
   - Línea 11: `static const String _appId = 'TU_APP_ID_AQUI';`
   - Línea 12: `static const String _appKey = 'TU_APP_KEY_AQUI';`
   - Reemplaza con tus credenciales

#### Ejemplo:
```dart
static const String _appId = '12345678';
static const String _appKey = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';
```

---

### 3. Nutritionix (Alternativa)

**Plan Gratuito:** 500 requests/día  
**Ventaja:** Base de datos de restaurantes y marcas

Si quieres usar Nutritionix en lugar de las anteriores, contacta al desarrollador.

---

## 🚀 IMPLEMENTACIÓN ACTUAL

**Servicio activo:** Clarifai  
**Ubicación:** `lib/screens/nutrition/nutrition_screen.dart` línea 28

Para cambiar de servicio:
1. Importa el servicio deseado
2. Cambia la línea 28 de `ClarifaiService()` a `EdamamService()`
3. Actualiza la línea 123 del método `_captureAndAnalyzeImage()`

---

## 📊 COMPARACIÓN DE SERVICIOS

| Servicio | Requests/mes | Reconocimiento Visual | Precisión Nutricional | Facilidad |
|----------|--------------|----------------------|---------------------|-----------|
| Clarifai | 5,000 | ✅ Sí | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Edamam   | 1,000 | ❌ No (texto) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Gemini   | Variable | ✅ Sí | ⭐⭐⭐⭐ | ⭐⭐ |

**Recomendación:** Usa **Clarifai** para reconocimiento visual automático.

---

## 🔒 SEGURIDAD

**IMPORTANTE:** Nunca subas tus API Keys a GitHub.

- ✅ Las API Keys están en archivos `.dart` locales
- ✅ Estos archivos están en `.gitignore`
- ❌ NO hagas commit de archivos con keys reales

---

## 🐛 SOLUCIÓN DE PROBLEMAS

### Error: "Clarifai no está configurado"
- Verifica que hayas reemplazado `TU_CLARIFAI_API_KEY_AQUI`
- Asegúrate de que el token no tenga espacios al inicio/final

### Error: "HTTP 401 Unauthorized"
- Tu API Key es inválida o expiró
- Genera una nueva en el dashboard

### Error: "HTTP 429 Too Many Requests"
- Excediste el límite gratuito del mes
- Espera al próximo mes o actualiza a plan pagado

---

## 📞 SOPORTE

Si necesitas ayuda con la configuración:
- Documentación Clarifai: https://docs.clarifai.com/
- Documentación Edamam: https://developer.edamam.com/edamam-docs-recipe-api
