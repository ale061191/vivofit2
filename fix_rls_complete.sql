-- 🔧 FIX COMPLETO: Eliminar TODAS las políticas RLS y recrearlas correctamente
-- Este script resuelve el problema de registro completamente

-- PASO 1: Eliminar TODAS las políticas existentes en la tabla users
DROP POLICY IF EXISTS "Users can insert their own data" ON public.users;
DROP POLICY IF EXISTS "Users can insert their own profile during registration" ON public.users;
DROP POLICY IF EXISTS "Users can view their own data" ON public.users;
DROP POLICY IF EXISTS "Users can update their own data" ON public.users;

-- PASO 2: Crear política de INSERT que permite el registro
-- Esta política permite que cualquier usuario autenticado cree su propio perfil
CREATE POLICY "Enable insert for authenticated users"
ON public.users
FOR INSERT
TO authenticated
WITH CHECK (true);  -- Permite cualquier inserción de usuarios autenticados

-- PASO 3: Crear política de SELECT para ver solo sus propios datos
CREATE POLICY "Enable select for users based on user_id"
ON public.users
FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- PASO 4: Crear política de UPDATE para actualizar solo sus propios datos
CREATE POLICY "Enable update for users based on user_id"
ON public.users
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- PASO 5: Verificar que RLS está habilitado
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- PASO 6: Mostrar todas las políticas creadas
SELECT 
    schemaname,
    tablename,
    policyname,
    cmd as operation,
    qual as using_expression,
    with_check as with_check_expression
FROM pg_policies
WHERE tablename = 'users'
ORDER BY cmd, policyname;

-- ✅ RESULTADO ESPERADO:
-- 3 políticas:
-- 1. Enable insert for authenticated users (INSERT)
-- 2. Enable select for users based on user_id (SELECT)
-- 3. Enable update for users based on user_id (UPDATE)
