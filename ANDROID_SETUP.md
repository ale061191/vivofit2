# 📱 Instalación de Android Studio para VivoFit

## 🎯 Objetivo
Configurar el entorno Android para poder generar APKs de la aplicación VivoFit.

---

## 📋 Requisitos
- Windows 10/11
- **8 GB RAM mínimo** (16 GB recomendado)
- **10 GB espacio en disco** para Android Studio + SDK
- Conexión a internet estable

---

## 🚀 Pasos de Instalación

### Paso 1: Descargar Android Studio
1. Ve a: https://developer.android.com/studio
2. Descarga **Android Studio Ladybug | 2024.2.1** (última versión estable)
3. Tamaño del instalador: ~1 GB
4. Tiempo de descarga: 5-15 minutos (según tu internet)

### Paso 2: Instalar Android Studio
```
1. Ejecuta el instalador descargado
2. Acepta los términos y condiciones
3. Selecciona "Standard" installation
4. Elige el tema (Darcula es el oscuro, como tu app 😎)
5. Clic en "Finish" y espera a que descargue componentes
```

**⏱️ Tiempo estimado:** 20-40 minutos (descarga SDK components)

### Paso 3: Configurar SDK
1. Abre Android Studio
2. Ve a **More Actions** > **SDK Manager**
3. En la pestaña **SDK Platforms**, marca:
   - ✅ Android 15.0 (VanillaIceCream) - API 35
   - ✅ Android 14.0 (UpsideDownCake) - API 34  
   - ✅ Android 13.0 (Tiramisu) - API 33

4. En la pestaña **SDK Tools**, marca:
   - ✅ Android SDK Build-Tools
   - ✅ Android SDK Command-line Tools
   - ✅ Android Emulator
   - ✅ Android SDK Platform-Tools
   - ✅ Google Play services

5. Clic en **Apply** y espera la descarga (~5-10 GB)

### Paso 4: Aceptar Licencias de Android
```bash
# En PowerShell (como administrador):
flutter doctor --android-licenses

# Presiona 'y' para aceptar todas las licencias
```

### Paso 5: Verificar Instalación
```bash
flutter doctor -v
```

Deberías ver:
```
[√] Android toolchain - develop for Android devices (Android SDK version X.X.X)
[√] Android Studio (version 2024.2)
```

---

## 🔧 Configuración de Variables de Entorno (Si es necesario)

Si `flutter doctor` no detecta el SDK:

### Windows 10/11:
1. Presiona `Win + R`, escribe `sysdm.cpl`, Enter
2. Pestaña **Avanzado** > **Variables de entorno**
3. En **Variables del sistema**, clic en **Nueva**:
   - Nombre: `ANDROID_HOME`
   - Valor: `C:\Users\TU_USUARIO\AppData\Local\Android\Sdk`
4. Edita la variable **Path** y agrega:
   - `%ANDROID_HOME%\platform-tools`
   - `%ANDROID_HOME%\tools`
5. Clic **Aceptar** en todas las ventanas
6. **Reinicia PowerShell** y ejecuta:
   ```bash
   flutter doctor
   ```

---

## 📱 Configurar Dispositivo Android Físico

### Para probar en tu smartphone:

1. **Habilita Opciones de Desarrollador:**
   - Ve a Configuración > Acerca del teléfono
   - Toca 7 veces sobre "Número de compilación"
   - Verás "Ya eres desarrollador"

2. **Habilita Depuración USB:**
   - Ve a Configuración > Sistema > Opciones de desarrollador
   - Activa "Depuración USB"

3. **Conecta tu smartphone al PC:**
   - Usa cable USB
   - Autoriza la computadora en el teléfono (aparecerá popup)

4. **Verifica la conexión:**
   ```bash
   adb devices
   ```
   
   Deberías ver:
   ```
   List of devices attached
   ABC123DEF456    device
   ```

---

## 🎮 Configurar Emulador (Opcional)

Si quieres probar sin smartphone físico:

1. Abre Android Studio
2. **More Actions** > **Virtual Device Manager**
3. **Create Device**
4. Selecciona un dispositivo (ej: Pixel 8)
5. Descarga una imagen del sistema (ej: Android 14)
6. Clic en **Finish**

**Lanzar emulador:**
```bash
flutter emulators

# Listar emuladores
flutter emulators --launch <emulator-id>
```

---

## ⚡ Comandos Rápidos Post-Instalación

```bash
# Verificar todo está ok
flutter doctor -v

# Ver dispositivos conectados
flutter devices

# Aceptar licencias de Android
flutter doctor --android-licenses

# Generar APK debug
flutter build apk --debug

# Instalar en dispositivo conectado
flutter install

# Ejecutar app en dispositivo/emulador
flutter run
```

---

## 🐛 Solución de Problemas Comunes

### "Unable to locate Android SDK"
```bash
# Configurar manualmente la ruta del SDK
flutter config --android-sdk C:\Users\TU_USUARIO\AppData\Local\Android\Sdk
```

### "cmdline-tools component is missing"
1. Abre Android Studio
2. SDK Manager > SDK Tools
3. Marca "Android SDK Command-line Tools"
4. Apply

### "adb: command not found"
Agrega a la variable PATH:
```
C:\Users\TU_USUARIO\AppData\Local\Android\Sdk\platform-tools
```

### Emulador muy lento
- Habilita "Intel HAXM" en SDK Tools
- O usa tu smartphone físico (más rápido)

---

## 📊 Checklist de Instalación

- [ ] Android Studio descargado e instalado
- [ ] SDK Platforms instalados (API 33, 34, 35)
- [ ] SDK Tools instalados
- [ ] Licencias aceptadas (`flutter doctor --android-licenses`)
- [ ] `flutter doctor` muestra Android toolchain ✓
- [ ] Variables de entorno configuradas (si fue necesario)
- [ ] Dispositivo físico configurado O emulador creado
- [ ] `adb devices` muestra dispositivo conectado

---

## ⏱️ Tiempo Total Estimado

| Tarea | Tiempo |
|-------|--------|
| Descargar Android Studio | 5-15 min |
| Instalar Android Studio | 10-15 min |
| Descargar SDK Components | 15-30 min |
| Configurar variables | 5 min |
| Configurar dispositivo | 5 min |
| **TOTAL** | **40-70 min** |

---

## 🎯 Siguiente Paso

Una vez instalado, ejecuta:
```bash
cd C:\Users\Usuario\Documents\vivoFit
flutter build apk --debug
```

**Ubicación del APK:**
```
build\app\outputs\flutter-apk\app-debug.apk
```

---

## 💡 Alternativa: Usar GitHub Actions (Sin instalar nada)

Si no quieres instalar Android Studio localmente, puedo ayudarte a configurar GitHub Actions para que compile el APK en la nube automáticamente.

**Ventajas:**
- ✅ No usa espacio en tu PC
- ✅ Compilación automática en cada push
- ✅ Genera APK en la nube

**¿Te interesa esta opción?**

---

**Última actualización:** 5 de Noviembre, 2025
