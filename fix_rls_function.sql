-- 🎯 SOLUCIÓN DEFINITIVA: Función para crear usuarios que bypasea RLS
-- Esta función se ejecuta con privilegios de SECURITY DEFINER
-- lo que significa que ignora las políticas RLS

-- 1. Eliminar función si existe
DROP FUNCTION IF EXISTS public.create_user_profile(uuid, text, text);

-- 2. Crear función que inserta usuarios sin restricciones RLS
CREATE OR REPLACE FUNCTION public.create_user_profile(
  user_id uuid,
  user_email text,
  user_name text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER -- Esto ejecuta la función con privilegios del dueño, ignorando RLS
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, email, name, created_at)
  VALUES (user_id, user_email, user_name, now())
  ON CONFLICT (id) DO NOTHING; -- Si ya existe, no hace nada
END;
$$;

-- 3. Dar permisos a usuarios autenticados para ejecutar esta función
GRANT EXECUTE ON FUNCTION public.create_user_profile(uuid, text, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_user_profile(uuid, text, text) TO anon;

-- 4. Verificar que la función se creó correctamente
SELECT 
  routine_name,
  routine_type,
  security_type
FROM information_schema.routines
WHERE routine_name = 'create_user_profile';

-- ✅ RESULTADO ESPERADO:
-- routine_name: create_user_profile
-- routine_type: FUNCTION
-- security_type: DEFINER
