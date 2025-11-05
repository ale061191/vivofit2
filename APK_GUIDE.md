# 📱 Guía Rápida: Generar APK de VivoFit

## Opción 1: APK Rápido para Testing (Sin Supabase)

Si quieres generar un APK **AHORA** para probar en tu smartphone (con los datos locales actuales):

### Paso 1: Preparar el entorno
```bash
# Ir al directorio del proyecto
cd C:\Users\Usuario\Documents\vivoFit

# Limpiar builds anteriores
flutter clean

# Obtener dependencias
flutter pub get
```

### Paso 2: Generar APK de Debug (más rápido)
```bash
# APK de debug (no requiere keystore)
flutter build apk --debug

# Ubicación: build/app/outputs/flutter-apk/app-debug.apk
```

### Paso 3: Instalar en tu smartphone
**Opción A - Con cable USB:**
```bash
# 1. Conecta tu smartphone al PC
# 2. Habilita "Depuración USB" en opciones de desarrollador
# 3. Ejecuta:
flutter install

# O manualmente:
adb install build/app/outputs/flutter-apk/app-debug.apk
```

**Opción B - Sin cable (manual):**
1. Copia `build/app/outputs/flutter-apk/app-debug.apk` a tu teléfono
2. En tu teléfono:
   - Ve a Configuración > Seguridad
   - Habilita "Orígenes desconocidos" o "Instalar apps desconocidas"
3. Abre el archivo APK desde el administrador de archivos
4. Instala la app

---

## Opción 2: APK de Producción (Con firma - Recomendado)

Para una APK más profesional y optimizada:

### Paso 1: Generar Keystore (solo una vez)
```bash
keytool -genkey -v -keystore C:\Users\Usuario\vivofit-key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias vivofit-key
```

**Datos a ingresar:**
```
Password del keystore: [crea uno fuerte y GUÁRDALO]
Confirmar password: [mismo password]
¿Cuál es su nombre y apellido?: Carlos Rodriguez
¿Cuál es el nombre de su unidad de organización?: VivoFit
¿Cuál es el nombre de su organización?: VivoFit App
¿Cuál es el nombre de su ciudad o localidad?: Caracas
¿Cuál es el nombre de su estado o provincia?: Miranda
¿Cuál es el código de país de dos letras?: VE
¿Es correcto? [no]: si
Password para <vivofit-key>: [Enter = mismo password]
```

### Paso 2: Crear archivo de propiedades
Crear `android/key.properties`:
```properties
storePassword=TU_PASSWORD_AQUI
keyPassword=TU_PASSWORD_AQUI
keyAlias=vivofit-key
storeFile=C:\\Users\\Usuario\\vivofit-key.jks
```

**⚠️ IMPORTANTE:** Agregar a `.gitignore`:
```
android/key.properties
*.jks
*.keystore
```

### Paso 3: Configurar build.gradle
Editar `android/app/build.gradle`, agregar ANTES de `android {`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Dentro de `android {`, agregar:
```gradle
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
    }
}
```

### Paso 4: Generar APK Release
```bash
# Limpiar
flutter clean
flutter pub get

# Generar APK firmado
flutter build apk --release

# O generar por arquitectura (APKs más pequeños)
flutter build apk --split-per-abi --release
```

**APKs generados:**
- Universal: `build/app/outputs/flutter-apk/app-release.apk` (~40-50 MB)
- Por ABI:
  - `app-armeabi-v7a-release.apk` (~20 MB) - Para teléfonos antiguos
  - `app-arm64-v8a-release.apk` (~25 MB) - Para teléfonos modernos (64-bit)
  - `app-x86_64-release.apk` (~27 MB) - Para emuladores

**Recomendación:** Usa `app-arm64-v8a-release.apk` para smartphones modernos.

---

## Opción 3: App Bundle (Para publicar en Play Store)

Si más adelante quieres publicar en Google Play:
```bash
flutter build appbundle --release

# Genera: build/app/outputs/bundle/release/app-release.aab
```

---

## 📋 Checklist Pre-APK

Antes de generar el APK, verifica:

### Configuración de la App
- [ ] `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <application
      android:label="VivoFit"
      android:icon="@mipmap/ic_launcher">
  ```

- [ ] Versión en `pubspec.yaml`:
  ```yaml
  version: 1.0.0+1
  # 1.0.0 = versión mostrada al usuario
  # +1 = build number (incrementa en cada release)
  ```

### Permisos Necesarios
En `AndroidManifest.xml`, verifica que tengas:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### Proguard (Ofuscación de código)
Crear `android/app/proguard-rules.pro`:
```
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
```

---

## 🐛 Solución de Problemas Comunes

### Error: "No connected devices"
```bash
# Ver dispositivos conectados
adb devices

# Reiniciar ADB
adb kill-server
adb start-server
```

### Error: "Gradle build failed"
```bash
# Limpiar Gradle
cd android
./gradlew clean
cd ..

# O en Windows:
cd android
gradlew.bat clean
cd ..
```

### Error: "Unable to find bundletool"
```bash
# Actualizar Flutter
flutter upgrade

# Limpiar y reinstalar
flutter clean
flutter pub get
```

### APK muy grande (> 50 MB)
```bash
# Generar APKs por arquitectura (más pequeños)
flutter build apk --split-per-abi --release

# Verificar tamaño
dir build\app\outputs\flutter-apk\*.apk
```

---

## 📊 Comparación de Tamaños

| Tipo de APK | Tamaño Aproximado | Cuándo Usar |
|-------------|-------------------|-------------|
| Debug | ~50-60 MB | Testing rápido |
| Release Universal | ~40-50 MB | Compartir con varios usuarios |
| Release arm64-v8a | ~25 MB | Smartphones modernos (recomendado) |
| Release armeabi-v7a | ~20 MB | Smartphones antiguos |
| App Bundle (.aab) | ~30 MB | Publicar en Play Store |

---

## 🚀 Comandos Rápidos de Referencia

```bash
# APK Debug (rápido, para testing)
flutter build apk --debug

# APK Release (optimizado, requiere keystore)
flutter build apk --release

# APK Release por arquitectura (más pequeño)
flutter build apk --split-per-abi --release

# Instalar directamente en teléfono conectado
flutter install

# Ver dispositivos conectados
flutter devices

# Analizar tamaño del APK
flutter build apk --analyze-size

# Limpiar todo antes de build
flutter clean && flutter pub get && flutter build apk --release
```

---

## 📱 Testing en Smartphone

### Checklist de Testing
Una vez instalada la app en tu smartphone, verifica:

- [ ] **Login/Registro** funciona
- [ ] **Navegación** entre pantallas es fluida
- [ ] **Imágenes** se cargan correctamente
- [ ] **Gráficos** de analytics se muestran
- [ ] **Botones** responden al toque
- [ ] **Performance** es buena (no lag)
- [ ] **Orientación** (vertical/horizontal) funciona
- [ ] **Teclado** aparece en formularios
- [ ] **Datos** se persisten correctamente
- [ ] **No hay crashes** al navegar

---

## 💡 Recomendación

**Para tu primer APK de prueba:**

1. Usa `flutter build apk --debug` (más rápido, sin keystore)
2. Instala en tu smartphone para probar funcionalidad
3. Si todo funciona bien, entonces genera un APK release firmado
4. Después podemos migrar a Supabase y generar APK con backend real

**¿Quieres que generemos el APK ahora?** 🚀

Puedo guiarte paso a paso con cada comando y verificar que todo funcione correctamente.
