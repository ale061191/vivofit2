-- 🔧 FIX: Permitir inserción en tabla users durante el registro
-- Este script corrige el problema de RLS para permitir que los usuarios
-- se registren correctamente en la tabla users

-- 1. Eliminar política restrictiva de INSERT si existe
DROP POLICY IF EXISTS "Users can insert their own data" ON public.users;

-- 2. Crear nueva política que permita INSERT durante el registro
-- Esta política permite que un usuario recién registrado pueda crear su propio registro
CREATE POLICY "Users can insert their own profile during registration"
ON public.users
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- 3. Verificar que la política de SELECT siga funcionando
-- (Esta ya debería existir del schema original)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' 
        AND policyname = 'Users can view their own data'
    ) THEN
        CREATE POLICY "Users can view their own data"
        ON public.users
        FOR SELECT
        TO authenticated
        USING (auth.uid() = id);
    END IF;
END $$;

-- 4. Verificar que la política de UPDATE siga funcionando
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'users' 
        AND policyname = 'Users can update their own data'
    ) THEN
        CREATE POLICY "Users can update their own data"
        ON public.users
        FOR UPDATE
        TO authenticated
        USING (auth.uid() = id)
        WITH CHECK (auth.uid() = id);
    END IF;
END $$;

-- 5. Mostrar políticas actuales
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

-- ✅ Después de ejecutar este SQL:
-- 1. El usuario podrá registrarse correctamente
-- 2. Su registro se creará en la tabla users
-- 3. Solo podrá ver/editar sus propios datos (seguridad mantenida)
