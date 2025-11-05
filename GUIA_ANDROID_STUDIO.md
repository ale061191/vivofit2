# 📱 Guía Paso a Paso: Instalación de Android Studio

**Objetivo:** Configurar Android Studio para poder generar APKs de Vivofit  
**Tiempo estimado:** 40-70 minutos  
**Espacio requerido:** ~10 GB

---

## 🎯 Resumen Rápido

Vamos a:
1. ✅ Descargar e instalar Android Studio
2. ✅ Configurar el SDK de Android
3. ✅ Aceptar las licencias
4. ✅ Configurar variables de entorno
5. ✅ Verificar con Flutter
6. ✅ Generar tu primer APK

---

## 📋 Prerrequisitos

- ✅ Windows 11 (ya lo tienes)
- ✅ Flutter instalado (ya lo tienes - versión 3.35.7)
- ✅ VS Code instalado (ya lo tienes)
- ✅ ~10 GB de espacio libre en disco
- ✅ Conexión a internet estable

---

## 🚀 PASO 1: Descargar Android Studio

### 1.1 Ir al sitio oficial

1. Abre tu navegador
2. Ve a: **https://developer.android.com/studio**
3. Haz clic en el botón verde **"Download Android Studio"**

### 1.2 Aceptar términos

- Lee los términos y condiciones
- Marca la casilla **"I have read and agree..."**
- Haz clic en **"Download Android Studio ..."**

**⏱️ Tiempo estimado de descarga:** 5-15 minutos (depende de tu conexión)  
**📦 Tamaño del archivo:** ~1 GB

---

## 💻 PASO 2: Instalar Android Studio

### 2.1 Ejecutar el instalador

1. Una vez descargado, abre el archivo `.exe`
2. Si Windows pregunta: **"¿Deseas permitir que esta aplicación haga cambios?"** → Clic en **"Sí"**

### 2.2 Seguir el asistente de instalación

**Pantalla 1: Bienvenida**
- Clic en **"Next"**

**Pantalla 2: Componentes**
- ✅ Asegúrate que estén marcados:
  - ✅ Android Studio
  - ✅ Android Virtual Device
- Clic en **"Next"**

**Pantalla 3: Ubicación de instalación**
- Ruta por defecto: `C:\Program Files\Android\Android Studio`
- **Recomendación:** Dejar la ruta por defecto
- Clic en **"Next"**

**Pantalla 4: Carpeta del menú inicio**
- Dejar por defecto
- Clic en **"Install"**

**⏱️ Tiempo de instalación:** 5-10 minutos

**Pantalla 5: Finalizar**
- ✅ Marca **"Start Android Studio"**
- Clic en **"Finish"**

---

## ⚙️ PASO 3: Configuración Inicial de Android Studio

### 3.1 Primera apertura

Android Studio se abrirá automáticamente.

**Pantalla: "Import Android Studio Settings"**
- Selecciona: **"Do not import settings"**
- Clic en **"OK"**

### 3.2 Welcome Wizard

**Pantalla 1: Welcome**
- Clic en **"Next"**

**Pantalla 2: Install Type**
- Selecciona: **"Standard"** (recomendado)
- Clic en **"Next"**

**Pantalla 3: Select UI Theme**
- Elige tu tema preferido:
  - **Darcula** (oscuro) - recomendado para combinar con VS Code
  - **Light** (claro)
- Clic en **"Next"**

**Pantalla 4: Verify Settings**
- Revisa el resumen:
  - SDK Folder: `C:\Users\Usuario\AppData\Local\Android\Sdk`
  - Total space: ~8 GB
- ✅ **IMPORTANTE:** Anota la ruta del SDK (la necesitarás después)
- Clic en **"Next"**

**Pantalla 5: Downloading Components**
- Android Studio descargará:
  - Android SDK
  - Android SDK Platform
  - Android SDK Build-Tools
  - Android Emulator
  - Android SDK Platform-Tools
- ⏱️ **Tiempo estimado:** 15-30 minutos
- 📊 **Barra de progreso:** Espera a que llegue al 100%

**Pantalla 6: Finish**
- Clic en **"Finish"**

---

## 📦 PASO 4: Instalar SDK Adicionales (Importante)

### 4.1 Abrir SDK Manager

En la pantalla de bienvenida de Android Studio:
1. Clic en **"More Actions"** (tres puntos verticales)
2. Selecciona **"SDK Manager"**

### 4.2 Instalar SDKs recomendados

**Pestaña: "SDK Platforms"**
- ✅ Marca estas versiones:
  - ✅ **Android 15.0 (API 35)** - Último
  - ✅ **Android 14.0 (API 34)** - Estable
  - ✅ **Android 13.0 (API 33)** - Compatibilidad

**Pestaña: "SDK Tools"**
- ✅ Asegúrate que estén marcados:
  - ✅ Android SDK Build-Tools (última versión)
  - ✅ Android SDK Command-line Tools (latest)
  - ✅ Android SDK Platform-Tools
  - ✅ Android Emulator
  - ✅ Google Play services

**Aplicar cambios:**
1. Clic en **"Apply"**
2. Aparecerá ventana de confirmación
3. Clic en **"OK"**
4. ⏱️ Espera a que descargue e instale (5-15 minutos)
5. Clic en **"Finish"** cuando termine
6. Clic en **"OK"** para cerrar SDK Manager

---

## ⚖️ PASO 5: Aceptar Licencias de Android

### 5.1 Abrir PowerShell

1. Presiona **Windows + X**
2. Selecciona **"Windows PowerShell"**

### 5.2 Ejecutar comando de licencias

```powershell
flutter doctor --android-licenses
```

### 5.3 Aceptar todas las licencias

- Verás varios acuerdos de licencia
- Para cada uno:
  - Lee (opcional 😅)
  - Escribe: **`y`**
  - Presiona **Enter**
- Repite hasta que no aparezcan más licencias

**Salida esperada al final:**
```
All SDK package licenses accepted.
```

---

## 🌍 PASO 6: Configurar Variables de Entorno (Importante)

### 6.1 Abrir Configuración de Variables

1. Presiona **Windows + S**
2. Escribe: **"variables de entorno"**
3. Haz clic en: **"Editar las variables de entorno del sistema"**
4. En la ventana, clic en **"Variables de entorno..."** (abajo)

### 6.2 Crear ANDROID_HOME

**En "Variables de usuario":**
1. Clic en **"Nueva..."**
2. **Nombre de la variable:** `ANDROID_HOME`
3. **Valor de la variable:** `C:\Users\Usuario\AppData\Local\Android\Sdk`
   - ⚠️ **Importante:** Usa la ruta que anotaste en el Paso 3.2
4. Clic en **"Aceptar"**

### 6.3 Actualizar PATH

**En "Variables de usuario":**
1. Busca y selecciona la variable **"Path"**
2. Clic en **"Editar..."**
3. Clic en **"Nuevo"**
4. Agrega: `%ANDROID_HOME%\platform-tools`
5. Clic en **"Nuevo"** otra vez
6. Agrega: `%ANDROID_HOME%\tools`
7. Clic en **"Aceptar"** en todas las ventanas

### 6.4 Verificar configuración

**Cierra y vuelve a abrir PowerShell**, luego ejecuta:

```powershell
echo $env:ANDROID_HOME
```

**Salida esperada:**
```
C:\Users\Usuario\AppData\Local\Android\Sdk
```

---

## ✅ PASO 7: Verificar con Flutter Doctor

### 7.1 Ejecutar diagnóstico completo

En PowerShell:

```powershell
flutter doctor -v
```

### 7.2 Revisar salida

**Antes (sin Android Studio):**
```
[✗] Android toolchain - Unable to locate Android SDK
```

**Después (con Android Studio correctamente instalado):**
```
[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
    • Android SDK at C:\Users\Usuario\AppData\Local\Android\Sdk
    • Platform android-35, build-tools 35.0.0
    • Java binary at: C:\Program Files\Android\Android Studio\jbr\bin\java
    • Java version OpenJDK Runtime Environment (build ...)
    • All Android licenses accepted.
```

---

## 🎉 PASO 8: Generar tu Primer APK

### 8.1 Limpiar proyecto

```powershell
cd C:\Users\Usuario\Documents\vivoFit
flutter clean
```

### 8.2 Obtener dependencias

```powershell
flutter pub get
```

### 8.3 Generar APK de prueba (Debug)

```powershell
flutter build apk --debug
```

**⏱️ Primera vez:** 5-10 minutos  
**Siguientes veces:** 2-3 minutos

### 8.4 Ubicación del APK

Si todo sale bien, verás:
```
✓ Built build\app\outputs\flutter-apk\app-debug.apk (XX.X MB)
```

**Ruta completa:**
```
C:\Users\Usuario\Documents\vivoFit\build\app\outputs\flutter-apk\app-debug.apk
```

### 8.5 Generar APK de producción (Release)

Para distribuir la app:

```powershell
flutter build apk --release --split-per-abi
```

Esto generará 3 APKs optimizados:
- `app-arm64-v8a-release.apk` (para la mayoría de dispositivos modernos)
- `app-armeabi-v7a-release.apk` (para dispositivos más antiguos)
- `app-x86_64-release.apk` (para emuladores x86)

---

## 📱 PASO 9: Instalar APK en tu Smartphone

### 9.1 Preparar tu teléfono

**En tu smartphone Android:**
1. Ve a **Configuración**
2. Busca **"Acerca del teléfono"** o **"About phone"**
3. Toca 7 veces en **"Número de compilación"**
4. Mensaje: **"Ahora eres desarrollador"**

### 9.2 Activar depuración USB

1. Ve a **Configuración**
2. Busca **"Opciones de desarrollador"** o **"Developer options"**
3. Activa: ✅ **"Depuración USB"**

### 9.3 Conectar teléfono

1. Conecta tu smartphone a la PC con cable USB
2. En el teléfono aparecerá: **"¿Permitir depuración USB?"**
3. Toca: **"Permitir"** o **"Allow"**

### 9.4 Verificar conexión

En PowerShell:

```powershell
flutter devices
```

**Salida esperada:**
```
Found 3 connected devices:
  SM G991B (mobile) • R58N50XXXXX • android-arm64 • Android 14 (API 34)
  Windows (desktop) • windows     • windows-x64    • Microsoft Windows...
  Chrome (web)      • chrome      • web-javascript • Google Chrome...
```

### 9.5 Instalar directamente desde Flutter

**Opción A: Instalar y ejecutar**
```powershell
flutter run --release
```

**Opción B: Solo instalar APK**
```powershell
flutter install
```

**Opción C: Transferir APK manualmente**
1. Copia el archivo `app-release.apk` a tu teléfono
2. En el teléfono, abre el archivo con un gestor de archivos
3. Toca **"Instalar"**
4. Si pregunta por fuentes desconocidas, permite la instalación

---

## 🔧 Solución de Problemas Comunes

### ❌ Error: "Unable to locate Android SDK"

**Solución:**
1. Verifica que `ANDROID_HOME` esté configurada correctamente
2. Reinicia PowerShell o la PC
3. Ejecuta: `flutter doctor -v`

---

### ❌ Error: "Android licenses not accepted"

**Solución:**
```powershell
flutter doctor --android-licenses
```
Acepta todas presionando `y` + Enter

---

### ❌ Error: "No connected devices"

**Solución:**
1. Desconecta y reconecta el cable USB
2. Asegúrate que la depuración USB esté activada
3. Intenta otro cable USB (muchos cables solo cargan, no transfieren datos)
4. Ejecuta: `adb devices` para ver dispositivos conectados

---

### ❌ Error: "Gradle build failed"

**Solución:**
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

---

### ❌ Error: "Java not found"

**Solución:**
Android Studio incluye Java. Asegúrate de:
1. Haber instalado Android Studio completamente
2. Reiniciar la PC después de la instalación

---

## 🎓 Comandos Útiles de Referencia

### Gestión de APKs
```powershell
# Limpiar proyecto
flutter clean

# APK debug (pruebas)
flutter build apk --debug

# APK release (producción)
flutter build apk --release

# APK por arquitectura (más pequeños)
flutter build apk --release --split-per-abi

# App Bundle (para Google Play Store)
flutter build appbundle --release
```

### Diagnóstico
```powershell
# Verificar instalación completa
flutter doctor -v

# Ver dispositivos conectados
flutter devices

# Ver dispositivos ADB
adb devices

# Verificar licencias
flutter doctor --android-licenses
```

### Ejecución
```powershell
# Ejecutar en dispositivo conectado
flutter run

# Ejecutar en modo release
flutter run --release

# Instalar sin ejecutar
flutter install
```

---

## 📊 Tiempo Total Estimado

| Paso | Actividad | Tiempo |
|------|-----------|--------|
| 1 | Descargar Android Studio | 5-15 min |
| 2 | Instalar Android Studio | 5-10 min |
| 3 | Configuración inicial | 15-30 min |
| 4 | Instalar SDKs adicionales | 5-15 min |
| 5 | Aceptar licencias | 2-5 min |
| 6 | Variables de entorno | 3-5 min |
| 7 | Flutter doctor | 2 min |
| 8 | Generar primer APK | 5-10 min |
| 9 | Instalar en smartphone | 5-10 min |
| **TOTAL** | | **47-102 minutos** |

**Promedio realista: ~60-70 minutos** ⏱️

---

## ✅ Checklist Final

Marca cada ítem cuando lo completes:

- [ ] Android Studio descargado
- [ ] Android Studio instalado
- [ ] Configuración inicial completada
- [ ] SDKs adicionales instalados (API 33, 34, 35)
- [ ] Licencias de Android aceptadas
- [ ] Variable ANDROID_HOME creada
- [ ] PATH actualizado con platform-tools y tools
- [ ] `flutter doctor` muestra ✓ en Android toolchain
- [ ] Primer APK debug generado exitosamente
- [ ] APK instalado en smartphone
- [ ] Vivofit ejecutándose en tu dispositivo 🎉

---

## 🎯 Próximos Pasos

Una vez completada la instalación:

1. ✅ **Probar la app en tu smartphone**
   - Login/registro
   - Navegar entre pantallas
   - Verificar sincronización de datos (Supabase)
   - Probar el cálculo de IMC
   - Revisar gráficos de progreso

2. ✅ **Documentar bugs o problemas**
   - Toma screenshots si encuentras errores
   - Anota comportamientos inesperados
   - Reporta al equipo de desarrollo

3. ✅ **Configurar GitHub Actions (Opcional)**
   - Para automatizar la generación de APKs en cada commit
   - Ver archivo: `APK_GUIDE.md` sección "GitHub Actions"

4. ✅ **Terminar migración a Supabase**
   - Auditar NutritionScreen
   - Auditar BlogScreen
   - Eliminar servicios legacy cuando todo esté migrado

---

## 📚 Recursos Adicionales

- **Flutter Docs:** https://docs.flutter.dev/deployment/android
- **Android Studio:** https://developer.android.com/studio/intro
- **Supabase Docs:** https://supabase.com/docs
- **Vivofit Repo:** https://github.com/ale061191/vivofit2

---

## 🆘 ¿Necesitas Ayuda?

Si encuentras algún problema:
1. Revisa la sección **"Solución de Problemas Comunes"**
2. Ejecuta `flutter doctor -v` y comparte la salida
3. Busca el error en Google: `flutter [tu error]`
4. Consulta en Discord/Slack del equipo

---

**Última actualización:** 5 de Noviembre 2025  
**Versión:** 1.0  
**Autor:** GitHub Copilot - Vivofit Team

¡Buena suerte con la instalación! 🚀💪
