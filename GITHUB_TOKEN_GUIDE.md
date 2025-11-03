# 🔐 Guía de Uso del Token de GitHub

## ⚠️ IMPORTANTE
Este archivo NO contiene el token real. El token está guardado de forma segura en `.env.local` que está en `.gitignore`.

---

## 📝 Cómo hacer push a GitHub

Cada vez que quieras subir cambios a GitHub, tienes dos opciones:

### **Opción 1: Usar el token temporalmente (Recomendado)**

```bash
# 1. Lee el token desde .env.local
# El token está en la variable GITHUB_TOKEN

# 2. Configura la URL con el token temporalmente
git remote set-url origin https://TU_TOKEN@github.com/ale061191/vivofit2.git

# 3. Haz el push
git push

# 4. Limpia la URL (seguridad)
git remote set-url origin https://github.com/ale061191/vivofit2.git
```

### **Opción 2: Dejar que Git te pida el token**

```bash
# Configura Git Credential Manager
git config --global credential.helper manager

# Ahora cuando hagas push, te pedirá:
git push

# Username: ale061191
# Password: [pega tu token aquí]
```

---

## 🔄 Workflow típico para commits

```bash
# 1. Ver cambios
git status

# 2. Agregar archivos modificados
git add .

# 3. Hacer commit con mensaje descriptivo
git commit -m "🎨 Descripción de los cambios"

# 4. Subir a GitHub (usa Opción 1 o 2 arriba)
git push
```

---

## 🔑 Si pierdes el token

1. Ve a: https://github.com/settings/tokens
2. Encuentra tu token "Vivofit App - Local Development"
3. Click en "Regenerate token"
4. Actualiza el token en `.env.local`

---

## 📚 Comandos útiles

```bash
# Ver configuración remota
git remote -v

# Ver historial de commits
git log --oneline

# Ver ramas
git branch -a

# Crear nueva rama
git checkout -b feature/nueva-funcionalidad

# Cambiar de rama
git checkout main
```

---

## 🛡️ Seguridad

- ✅ El token está en `.env.local` (ignorado por Git)
- ✅ NUNCA hagas commit del token
- ✅ Revoca el token si lo compartes accidentalmente
- ✅ Usa tokens con permisos mínimos necesarios

---

**Última actualización:** Noviembre 3, 2025
