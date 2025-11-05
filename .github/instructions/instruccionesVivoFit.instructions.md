---
applyTo: '**'
---

# Instrucciones para el Agente de GitHub Copilot PRO (Claude Sonnet 4.5)

## 1. Revisión y cumplimiento de guía de estilos

### Antes de desarrollar cualquier componente, página, vista o funcionalidad:
- **SIEMPRE** revisa primero la guía de estilos vigente que has definido (colores, tipografía, animaciones, espaciados, iconografía).
- Aplica **estrictamente** los valores especificados:
  - **Fondo:** Color(0xFF161616) - negro
  - **Acentos:** Color(0xFFFF9900) - naranja brillante
  - **Secundarios:** gris claro y blanco
  - **Tipografía:** moderna y legible, títulos en negrita (Google Fonts Inter)
  - **Espaciado:** generoso y ordenado según ejemplos establecidos
  - **Animaciones:** solo usar si están permitidas explícitamente por el usuario

### Restricciones importantes:
- ❌ **NO** agregues ni modifiques componentes, colores, fuentes, animaciones, iconos o efectos a la guía de estilos salvo que te lo solicite expresamente el usuario.
- ❌ **NO** hagas ajustes automáticos ni actualizaciones salvo petición explícita.

---

## 2. Componentes reutilizables y sistema modular

### Principios de desarrollo de componentes:
- ✅ Todo componente debe ser **reutilizable** y **desacoplado**
- ✅ Debe poder insertarse en cualquier sección o pantalla sin modificaciones
- ✅ Los componentes **solo pueden ser modificados** si el usuario lo solicita de forma específica
- ✅ Mantén los props bien **documentados** con comentarios claros
- ✅ Asegura que la integración entre componentes sea **consistente** y **retrocompatible**

### Proceso de creación de nuevos componentes:
1. Si surge la necesidad de nuevos componentes en la guía de estilos, **espera confirmación** antes de agregar, editar o eliminar
2. Cualquier propuesta extra de diseño, personalización o refactorización debe ser **consensuada** antes de realizarse
3. Documenta claramente el propósito, props, métodos expuestos y dependencias

---

## 3. Desarrollo supervisado y validaciones previas

### Antes de iniciar cualquier desarrollo:
1. ✅ Realiza una **validación interna** de las instrucciones recibidas
2. ✅ Verifica que todo cumple con la **guía de estilos** establecida
3. ✅ Confirma que respeta el **flujo de negocio** definido
4. ✅ **Pregunta** si existen consideraciones, permisos o preferencias adicionales antes de expandir funcionalidad fuera del scope inicial

### Restricciones de expansión:
- ❌ No expandas funcionalidad más allá del scope inicial sin consultar
- ❌ No agregues librerías o dependencias sin aprobación previa
- ❌ No modifiques arquitectura existente sin validación

---

## 4. Iteración y documentación

### Estándares de documentación:
- 📝 Documenta de manera **clara y ordenada** el propósito de cada:
  - Componente
  - Pantalla o vista
  - Bloque funcional
  - Servicio o utilidad
- 📝 Incluye siempre:
  - Dependencias requeridas
  - Props y su tipado
  - Métodos expuestos y su uso
  - Ejemplos de implementación

### Propuestas de mejora:
- 💡 Propón mejoras **solo tras consultar** y obtener aprobación del usuario
- 💡 Explica claramente el beneficio de la mejora propuesta
- 💡 Espera confirmación antes de implementar

---

## 5. Workflow ideal (SIEMPRE seguir este proceso)

### Paso 1: Revisión
- 🔍 Revisar la guía de colores y estilos vigente
- 🔍 Identificar los props requeridos para el componente/pantalla
- 🔍 Verificar si corresponde añadirlo a la guía de estilos

### Paso 2: Consulta
- ❓ Preguntar al usuario si hay consideraciones especiales
- ❓ Solicitar aprobación para agregar a la guía de estilos (si aplica)
- ❓ Confirmar scope y funcionalidad esperada

### Paso 3: Implementación
- ⚙️ Implementar el componente de manera **desacoplada**
- ⚙️ Asegurar **tipado fuerte** (TypeScript/Dart según el caso)
- ⚙️ Seguir **estrictamente** los colores y estilos definidos
- ⚙️ Crear componentes **reutilizables** y bien documentados

### Paso 4: Validación final
- ✅ Solicitar **aprobación** antes de hacer modificaciones de base
- ✅ Confirmar antes de introducir elementos nuevos a la guía de estilos
- ✅ Verificar que cumple con todos los estándares establecidos

---

## 6. Guía de estilos actual (Vivofit)

### Colores principales:
```dart
// lib/theme/color_palette.dart
static const Color background = Color(0xFF161616);      // Negro oscuro
static const Color primary = Color(0xFFFF9900);         // Naranja brillante
static const Color textPrimary = Color(0xFFFFFFFF);     // Blanco
static const Color textSecondary = Color(0xFFB0B0B0);   // Gris claro
static const Color cardBackground = Color(0xFF1E1E1E);  // Gris oscuro para cards
```

### Tipografía:
- **Familia:** Google Fonts - Inter
- **Títulos:** FontWeight.bold (700)
- **Subtítulos:** FontWeight.w600 (600)
- **Cuerpo:** FontWeight.normal (400)

### Espaciados estándar:
- Padding contenedores: `16.0`
- Spacing entre elementos: `12.0`
- Margin entre secciones: `24.0`
- Border radius estándar: `12.0`

### Componentes reutilizables existentes:
- `CustomButton` (primary, outlined, text variants)
- `ProgramCard`, `RoutineCard`, `FoodCard`, `ArticleCard`
- `BottomNavBar`
- `LoadingIndicator`, `EmptyState`, `ErrorDisplay`, `SectionHeader`
- `LockedContentOverlay`

### Dependencias aprobadas:
Ver `pubspec.yaml` para lista completa de dependencias permitidas.

---

## 7. Recordatorios críticos

### ⚠️ NUNCA hacer sin permiso explícito:
1. Modificar colores de la paleta establecida
2. Cambiar la tipografía (Google Fonts Inter)
3. Agregar nuevas dependencias al `pubspec.yaml`
4. Modificar componentes existentes sin consultar
5. Agregar animaciones no solicitadas
6. Cambiar la arquitectura de navegación (GoRouter)
7. Modificar el patrón de estado (Provider)
8. **🔐 EXPONER claves API o credenciales en código** - Usar SIEMPRE `lib/config/api_keys.dart` (protegido por .gitignore)

### ✅ SIEMPRE hacer:
1. Consultar antes de expandir funcionalidad
2. Documentar props y métodos
3. Seguir estrictamente la guía de estilos
4. Crear componentes reutilizables y desacoplados
5. Validar instrucciones antes de implementar
6. Solicitar aprobación para cambios estructurales
7. **🔐 Proteger credenciales** usando `lib/config/api_keys.dart` (nunca hardcodear API keys)

---

## 8. Contexto del proyecto Vivofit

### Descripción:
Aplicación móvil de fitness en Flutter con gestión de programas de entrenamiento, rutinas, nutrición, blog y perfiles de usuario. Sistema de membresías premium con integración de pagos para Venezuela.

### Stack tecnológico:
- **Framework:** Flutter 3.2+ / Dart 3.2+
- **Estado:** Provider 6.1.1
- **Navegación:** GoRouter 13.0.0
- **UI:** Material Design 3 + Google Fonts
- **HTTP:** http 1.2.0
- **Localización:** Español Venezuela (es_VE)

### Características principales:
- Sistema de autenticación (login/registro)
- 4 pantallas principales: Home, Nutrición, Blog, Perfil
- Cálculo de IMC automático
- Sistema de membresías premium
- Pagos móviles venezolanos (validación de teléfono, cédula, referencia)
- Contenido bloqueado para usuarios sin membresía

### Credenciales de prueba:
- Email: `demo@vivofit.com`
- Password: `123456`

---

**Última actualización:** Noviembre 2, 2025  
**Versión de instrucciones:** 1.0