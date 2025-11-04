# 📸 INSTRUCCIONES PARA AGREGAR IMÁGENES AL ONBOARDING

## 🎯 Pasos a seguir:

### 1. Logo de VivoFit
**Archivo:** El logo naranja que compartiste
**Ubicación:** `assets/images/logo/vivofit_logo.png`
**Formato recomendado:** PNG con fondo transparente
**Tamaño recomendado:** 512x512 px o mayor (cuadrado)

### 2. Imágenes de Onboarding

#### Pantalla 1 - "BIENVENIDO A VIVOFIT"
**Archivo:** Mujer rubia con top gris y mancuernas
**Ubicación:** `assets/images/onboarding/onboarding_1.jpg`
**Descripción:** Mujer fitness con mancuernas en gimnasio

#### Pantalla 2 - "ENTRENA CON PROPÓSITO"
**Archivo:** Mujer tomando agua
**Ubicación:** `assets/images/onboarding/onboarding_2.jpg`
**Descripción:** Mujer atlética hidratándose después de entrenar

#### Pantalla 3 - "NUTRICIÓN INTELIGENTE"
**Archivo:** Hombre con torso trabajado
**Ubicación:** `assets/images/onboarding/onboarding_3.jpg`
**Descripción:** Hombre fitness con cuerpo definido y mancuernas en fondo oscuro

#### Pantalla 4 - "ALCANZA TUS METAS"
**Archivo:** Hombre con disco de peso
**Ubicación:** `assets/images/onboarding/onboarding_4.jpg`
**Descripción:** Hombre levantando disco de peso en gimnasio

---

## ⚙️ Formato y optimización:

### Para el logo:
- **Formato:** PNG (con transparencia)
- **Dimensiones:** 512x512 px o 1024x1024 px
- **Peso máximo:** 200 KB

### Para las imágenes de onboarding:
- **Formato:** JPG o PNG
- **Orientación:** Vertical (retrato)
- **Dimensiones recomendadas:** 1080x1920 px (formato móvil)
- **Peso máximo por imagen:** 500 KB (idealmente 300 KB)
- **Calidad:** 85-90% para balance entre calidad y tamaño

---

## 🔧 Cómo agregar las imágenes:

1. **Guarda las imágenes** en las carpetas correspondientes:
   ```
   vivoFit/
   ├── assets/
   │   └── images/
   │       ├── logo/
   │       │   └── vivofit_logo.png      ← Logo aquí
   │       └── onboarding/
   │           ├── onboarding_1.jpg      ← Imagen 1
   │           ├── onboarding_2.jpg      ← Imagen 2
   │           ├── onboarding_3.jpg      ← Imagen 3
   │           └── onboarding_4.jpg      ← Imagen 4
   ```

2. **Verifica los nombres** (deben coincidir exactamente):
   - ✅ `vivofit_logo.png`
   - ✅ `onboarding_1.jpg`
   - ✅ `onboarding_2.jpg`
   - ✅ `onboarding_3.jpg`
   - ✅ `onboarding_4.jpg`

3. **Ejecuta** en la terminal:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```

---

## 🎨 Características implementadas:

### ✅ Barra de progresión superior
- Se anima automáticamente al cambiar de página
- Gradiente naranja con efecto de brillo
- Avanza y retrocede según la página actual

### ✅ Logo en primera pantalla
- Aparece solo en la pantalla de bienvenida
- Centrado y con tamaño responsive
- Animación de fade-in al entrar

### ✅ Diseño responsive
- Tamaños de texto adaptables (pantallas < 700px)
- Espaciado optimizado para móviles
- Sombras en texto para mejor legibilidad

### ✅ Transiciones suaves
- Animaciones de fade y slide en cada cambio
- Swipe bidireccional (izquierda/derecha)
- Efecto bounce al llegar a los límites

---

## 🔄 Para actualizar después:

Si necesitas cambiar las imágenes más adelante:
1. Reemplaza el archivo en la carpeta correspondiente
2. Mantén el mismo nombre
3. **Hot reload** (`r` en terminal) o **Hot restart** (`R`)

---

## ❓ Notas importantes:

- El código tiene **fallbacks** si las imágenes no se encuentran
- El logo mostrará "VF" si no existe `vivofit_logo.png`
- Las imágenes mostrarán un ícono de gimnasio si no se encuentran
- Todas las imágenes se cargan como **assets locales** (no requieren internet)

---

## 📱 Resultado esperado:

**Pantalla 1:**
- Barra de progreso al 25%
- Logo de VivoFit centrado
- Texto "TRANSFORMA TU CUERPO"
- Imagen de mujer con mancuernas

**Pantallas 2-4:**
- Barra de progreso avanza (50%, 75%, 100%)
- Sin logo (solo texto e imagen)
- Transiciones suaves entre pantallas

**Interacción:**
- Deslizar hacia la izquierda → avanza
- Deslizar hacia la derecha → retrocede
- Botón "Siguiente" → avanza con animación
- Botón "Saltar" → va directo al login
