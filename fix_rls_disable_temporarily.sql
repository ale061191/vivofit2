-- 🔧 SOLUCIÓN TEMPORAL: Deshabilitar RLS completamente en tabla users
-- Esto permitirá que el registro funcione mientras investigamos el problema

-- OPCIÓN 1: Deshabilitar RLS temporalmente (SOLO PARA DESARROLLO)
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;

-- Verificar estado
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE tablename = 'users';

-- ⚠️ IMPORTANTE:
-- Con RLS deshabilitado, CUALQUIER usuario autenticado puede ver/editar TODOS los registros
-- Esto es SOLO para desarrollo y pruebas
-- Después del registro exitoso, debes HABILITAR RLS nuevamente con:
-- ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
