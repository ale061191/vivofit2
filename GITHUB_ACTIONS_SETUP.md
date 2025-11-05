# 🤖 Guía Rápida: Configurar GitHub Actions para APKs Automáticos

## 🎯 Objetivo
Generar APKs de Vivofit automáticamente en la nube de GitHub sin instalar Android Studio localmente.

---

## ⚡ Configuración Rápida (15 minutos)

### Paso 1: Ir a tu repositorio en GitHub

1. Abre tu navegador
2. Ve a: **https://github.com/ale061191/vivofit2**
3. Inicia sesión si no lo estás

---

### Paso 2: Crear el Workflow

1. Haz clic en la pestaña **"Actions"** (arriba)
2. Haz clic en **"New workflow"**
3. Haz clic en **"set up a workflow yourself"**
4. En el editor que aparece, **BORRA TODO** el contenido
5. **COPIA Y PEGA** el siguiente código:

```yaml
name: Build Flutter APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch: # Permite ejecutar manualmente

jobs:
  build:
    name: Build APK
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.7'
          channel: 'stable'
          cache: true
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Analyze code
        run: flutter analyze
        continue-on-error: true
      
      - name: Build Debug APK
        run: flutter build apk --debug --split-per-abi
      
      - name: Build Release APK
        run: flutter build apk --release --split-per-abi
      
      - name: Upload Debug APK artifacts
        uses: actions/upload-artifact@v4
        with:
          name: debug-apks
          path: |
            build/app/outputs/flutter-apk/*-debug.apk
          retention-days: 30
      
      - name: Upload Release APK artifacts
        uses: actions/upload-artifact@v4
        with:
          name: release-apks
          path: |
            build/app/outputs/flutter-apk/*-release.apk
          retention-days: 90
```

---

### Paso 3: Guardar el Workflow

1. En el campo **"Name your file"** (arriba), deja: `build-apk.yml`
2. Haz clic en el botón verde **"Commit changes..."** (arriba a la derecha)
3. En el popup que aparece:
   - **Commit message:** `🤖 Add GitHub Actions workflow for automatic APK builds`
   - **Description:** `Builds debug and release APKs automatically on every push to main`
4. Selecciona: **"Commit directly to the main branch"**
5. Haz clic en **"Commit changes"**

---

### Paso 4: Ejecutar el Workflow Manualmente (Primera vez)

1. Ve a la pestaña **"Actions"** de nuevo
2. En el sidebar izquierdo, haz clic en **"Build Flutter APK"**
3. Verás un botón **"Run workflow"** (derecha)
4. Haz clic en **"Run workflow"**
5. Selecciona **"Branch: main"**
6. Haz clic en **"Run workflow"** (botón verde)

---

### Paso 5: Ver el Progreso

1. Verás aparecer un nuevo workflow con un círculo amarillo girando 🟡
2. Haz clic en el nombre del workflow (ej: "🤖 Add GitHub Actions workflow...")
3. Haz clic en **"Build APK"** para ver los detalles
4. Verás cada paso ejecutándose en tiempo real:
   - ✅ Checkout code
   - ✅ Setup Java
   - ✅ Setup Flutter
   - ✅ Get dependencies
   - ⚠️ Analyze code (puede fallar, no es crítico)
   - ✅ Build Debug APK (~5-10 min)
   - ✅ Build Release APK (~5-10 min)
   - ✅ Upload artifacts

**⏱️ Tiempo total:** 10-15 minutos la primera vez, 5-8 minutos las siguientes

---

### Paso 6: Descargar los APKs

Cuando el workflow termine (círculo verde ✅):

1. Haz scroll hasta **abajo** de la página
2. En la sección **"Artifacts"** verás:
   - 📦 **debug-apks** - APKs de prueba (para desarrollo)
   - 📦 **release-apks** - APKs de producción (para distribución)

3. Haz clic en cualquiera para descargar un ZIP
4. Extrae el ZIP, encontrarás 3 APKs por tipo:
   - `app-arm64-v8a-release.apk` ← **Usa este** (para mayoría de smartphones)
   - `app-armeabi-v7a-release.apk` (para phones antiguos)
   - `app-x86_64-release.apk` (para emuladores)

---

## 📱 Instalar el APK en tu Smartphone

### Método 1: Transferir por cable USB

1. Conecta tu smartphone a la PC
2. Copia el archivo `app-arm64-v8a-release.apk` al teléfono
3. En el teléfono, abre el **Gestor de archivos**
4. Encuentra el APK y tócalo
5. Toca **"Instalar"**
6. Si pregunta por **"Fuentes desconocidas"**, permite la instalación

### Método 2: Transferir por WhatsApp/Telegram

1. Envíate el APK a ti mismo por WhatsApp o Telegram
2. Abre el mensaje en tu teléfono
3. Descarga el archivo
4. Tócalo para instalar

### Método 3: Google Drive/Dropbox

1. Sube el APK a Google Drive o Dropbox
2. Ábrelo desde tu teléfono
3. Descarga e instala

---

## 🎉 ¡Listo! A partir de ahora...

### Generación Automática:

Cada vez que hagas `git push origin main`:
- ✅ GitHub Actions se ejecutará automáticamente
- ✅ Generará nuevos APKs debug y release
- ✅ Los subirá como artifacts
- ✅ Estarán disponibles para descargar por 90 días

### Acceso Rápido:

Para descargar APKs de cualquier commit:
1. Ve a https://github.com/ale061191/vivofit2/actions
2. Haz clic en el workflow que quieres
3. Scroll down → Artifacts → Descargar

---

## 🔧 Comandos Git para Nuevos Cambios

Cuando hagas cambios en el código:

```powershell
# Ver cambios
git status

# Agregar todos los cambios
git add .

# Commit con mensaje
git commit -m "✨ Descripción del cambio"

# Subir a GitHub (esto disparará GitHub Actions)
git push origin main

# Luego ve a Actions en GitHub para descargar el APK nuevo
```

---

## 📊 Monitoreo y Notificaciones

### Ver historial de builds:
- https://github.com/ale061191/vivofit2/actions

### Recibir notificaciones:
1. Ve a tu repositorio en GitHub
2. Haz clic en **"Watch"** (arriba a la derecha)
3. Selecciona **"Custom" → "Workflows"**
4. Recibirás emails cuando fallen builds

---

## 🐛 Solución de Problemas

### ❌ El workflow falla en "Build APK"

**Posible causa:** Errores de compilación en el código

**Solución:**
1. Ve al log del error en Actions
2. Busca el mensaje de error específico
3. Corrígelo en tu código local
4. Haz commit y push de nuevo

---

### ❌ No aparecen los Artifacts

**Posible causa:** El workflow no terminó completamente

**Solución:**
1. Verifica que el workflow muestre el ícono verde ✅
2. Refresh la página
3. Los artifacts aparecen solo cuando el workflow termina exitosamente

---

### ❌ "Analyze code" falla

**¿Es problema?** ❌ NO - Es normal y no crítico

El paso tiene `continue-on-error: true`, así que aunque falle, los APKs se generarán igual.

---

## 🎯 Ventajas de GitHub Actions

| Ventaja | Descripción |
|---------|-------------|
| 🆓 **Gratis** | 2,000 minutos/mes en cuentas gratuitas |
| ☁️ **En la nube** | No usa espacio ni recursos de tu PC |
| ⚡ **Rápido** | Compilación en servidores potentes |
| 🔄 **Automático** | Sin intervención manual |
| 📦 **Historial** | APKs de cada commit disponibles |
| 🌍 **Accesible** | Descarga desde cualquier dispositivo |

---

## 📚 Recursos Adicionales

- **Tu repositorio:** https://github.com/ale061191/vivofit2
- **Actions:** https://github.com/ale061191/vivofit2/actions
- **Docs de GitHub Actions:** https://docs.github.com/en/actions
- **Flutter CI/CD:** https://docs.flutter.dev/deployment/cd

---

## ✅ Checklist

- [ ] Workflow `build-apk.yml` creado en GitHub
- [ ] Workflow ejecutado manualmente (primera vez)
- [ ] Build completado exitosamente ✅
- [ ] APKs descargados de Artifacts
- [ ] APK instalado en smartphone
- [ ] App funciona correctamente en el dispositivo
- [ ] Notificaciones configuradas (opcional)

---

**Próximo paso:** Crear el workflow siguiendo los pasos arriba. ¡Toma ~15 minutos! 🚀

---

**Última actualización:** 5 de Noviembre 2025  
**Autor:** GitHub Copilot - Vivofit Team
