-- ============================================
-- FIX PROFILE RLS POLICIES
-- Solución para error "Error al actualizar perfil"
-- Noviembre 6, 2025
-- ============================================

-- Este script arregla las políticas RLS de la tabla users
-- para permitir INSERT y UPDATE sin problemas

-- 1. Eliminar políticas existentes (si existen)
DROP POLICY IF EXISTS "Users can view their own data" ON users;
DROP POLICY IF EXISTS "Users can update their own data" ON users;
DROP POLICY IF EXISTS "Users can insert their own data" ON users;

-- 2. Crear políticas mejoradas con mejor manejo de permisos

-- Política SELECT: Usuarios pueden ver sus propios datos
CREATE POLICY "Users can view their own data" ON users
  FOR SELECT 
  USING (auth.uid() = id);

-- Política UPDATE: Usuarios pueden actualizar sus propios datos
CREATE POLICY "Users can update their own data" ON users
  FOR UPDATE 
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Política INSERT: Usuarios pueden insertar sus propios datos
CREATE POLICY "Users can insert their own data" ON users
  FOR INSERT 
  WITH CHECK (auth.uid() = id);

-- Política ALL (alternativa más permisiva si las anteriores fallan)
-- Descomentar solo si los problemas persisten después de aplicar las políticas anteriores
-- DROP POLICY IF EXISTS "Users can manage their own data" ON users;
-- CREATE POLICY "Users can manage their own data" ON users
--   FOR ALL 
--   USING (auth.uid() = id)
--   WITH CHECK (auth.uid() = id);

-- 3. Verificar que RLS esté habilitado
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 4. Verificar índices (para mejor performance)
CREATE INDEX IF NOT EXISTS idx_users_id ON users(id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ============================================
-- VERIFICACIÓN POST-INSTALACIÓN
-- ============================================
-- Ejecuta estas queries después de aplicar el script para verificar:

-- Ver todas las políticas de la tabla users:
-- SELECT * FROM pg_policies WHERE tablename = 'users';

-- Ver si RLS está habilitado:
-- SELECT relname, relrowsecurity FROM pg_class WHERE relname = 'users';

-- Probar INSERT manual (reemplaza 'TU_USER_ID' con tu ID real):
-- INSERT INTO users (id, email, name, age, height, weight) 
-- VALUES ('TU_USER_ID', 'test@vivofit.com', 'Test User', 25, 175, 70)
-- ON CONFLICT (id) DO UPDATE SET 
--   name = EXCLUDED.name, 
--   age = EXCLUDED.age, 
--   height = EXCLUDED.height, 
--   weight = EXCLUDED.weight;
