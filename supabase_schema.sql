-- ============================================
-- VIVOFIT DATABASE SCHEMA
-- Supabase PostgreSQL
-- ============================================

-- ============================================
-- 1. TABLA: users (Usuarios)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  phone TEXT,
  photo_url TEXT,
  height NUMERIC, -- en cm
  weight NUMERIC, -- en kg
  age INTEGER,
  gender TEXT CHECK (gender IN ('male', 'female', 'other')),
  location TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para users
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- ============================================
-- 2. TABLA: workout_sessions (Sesiones de Entrenamiento)
-- ============================================
CREATE TABLE IF NOT EXISTS workout_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  program_id TEXT NOT NULL,
  routine_id TEXT NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 0,
  calories_burned INTEGER NOT NULL DEFAULT 0,
  exercises_completed INTEGER DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para workout_sessions
CREATE INDEX idx_workout_sessions_user_id ON workout_sessions(user_id);
CREATE INDEX idx_workout_sessions_completed_at ON workout_sessions(completed_at);
CREATE INDEX idx_workout_sessions_user_completed ON workout_sessions(user_id, completed_at DESC);

-- ============================================
-- 3. TABLA: nutritional_analyses (Análisis Nutricionales con IA)
-- ============================================
CREATE TABLE IF NOT EXISTS nutritional_analyses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  food_name TEXT NOT NULL,
  portion_size TEXT,
  calories INTEGER NOT NULL DEFAULT 0,
  protein NUMERIC DEFAULT 0,
  carbs NUMERIC DEFAULT 0,
  fats NUMERIC DEFAULT 0,
  fiber NUMERIC DEFAULT 0,
  health_level TEXT CHECK (health_level IN ('bajo', 'medio', 'alto')),
  micronutrients JSONB DEFAULT '[]'::jsonb,
  benefits JSONB DEFAULT '[]'::jsonb,
  recommendations TEXT,
  suitable_for JSONB DEFAULT '[]'::jsonb,
  image_url TEXT,
  analyzed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para nutritional_analyses
CREATE INDEX idx_nutritional_analyses_user_id ON nutritional_analyses(user_id);
CREATE INDEX idx_nutritional_analyses_analyzed_at ON nutritional_analyses(analyzed_at DESC);
CREATE INDEX idx_nutritional_analyses_user_analyzed ON nutritional_analyses(user_id, analyzed_at DESC);

-- ============================================
-- 4. TABLA: bmi_history (Historial de IMC)
-- ============================================
CREATE TABLE IF NOT EXISTS bmi_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  bmi_value NUMERIC NOT NULL,
  weight NUMERIC NOT NULL,
  height NUMERIC NOT NULL,
  total_calories_burned INTEGER DEFAULT 0,
  recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para bmi_history
CREATE INDEX idx_bmi_history_user_id ON bmi_history(user_id);
CREATE INDEX idx_bmi_history_recorded_at ON bmi_history(recorded_at DESC);
CREATE INDEX idx_bmi_history_user_recorded ON bmi_history(user_id, recorded_at DESC);

-- ============================================
-- 5. TABLA: memberships (Membresías)
-- ============================================
CREATE TABLE IF NOT EXISTS memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  membership_type TEXT NOT NULL CHECK (membership_type IN ('premium', 'basic')),
  status TEXT NOT NULL CHECK (status IN ('active', 'expired', 'cancelled', 'pending')),
  payment_reference TEXT,
  payment_phone TEXT,
  payment_ci TEXT,
  payment_bank TEXT,
  started_at TIMESTAMP WITH TIME ZONE,
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para memberships
CREATE INDEX idx_memberships_user_id ON memberships(user_id);
CREATE INDEX idx_memberships_status ON memberships(status);
CREATE INDEX idx_memberships_expires_at ON memberships(expires_at);

-- ============================================
-- FUNCIONES Y TRIGGERS
-- ============================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para users
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger para memberships
CREATE TRIGGER update_memberships_updated_at
  BEFORE UPDATE ON memberships
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Habilitar RLS en todas las tablas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE nutritional_analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE bmi_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE memberships ENABLE ROW LEVEL SECURITY;

-- Políticas para users (los usuarios solo pueden ver/editar sus propios datos)
CREATE POLICY "Users can view their own data" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own data" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own data" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Políticas para workout_sessions
CREATE POLICY "Users can view their own workout sessions" ON workout_sessions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own workout sessions" ON workout_sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own workout sessions" ON workout_sessions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own workout sessions" ON workout_sessions
  FOR DELETE USING (auth.uid() = user_id);

-- Políticas para nutritional_analyses
CREATE POLICY "Users can view their own nutritional analyses" ON nutritional_analyses
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own nutritional analyses" ON nutritional_analyses
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own nutritional analyses" ON nutritional_analyses
  FOR DELETE USING (auth.uid() = user_id);

-- Políticas para bmi_history
CREATE POLICY "Users can view their own BMI history" ON bmi_history
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own BMI history" ON bmi_history
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para memberships
CREATE POLICY "Users can view their own memberships" ON memberships
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own memberships" ON memberships
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================
-- VISTAS ÚTILES
-- ============================================

-- Vista para estadísticas de usuario
CREATE OR REPLACE VIEW user_stats AS
SELECT 
  u.id as user_id,
  u.name,
  u.email,
  COUNT(DISTINCT ws.id) as total_workouts,
  COALESCE(SUM(ws.duration_minutes), 0) as total_minutes,
  COALESCE(SUM(ws.calories_burned), 0) as total_calories,
  COUNT(DISTINCT na.id) as total_food_analyses,
  (SELECT membership_type FROM memberships 
   WHERE user_id = u.id AND status = 'active' 
   ORDER BY expires_at DESC LIMIT 1) as current_membership
FROM users u
LEFT JOIN workout_sessions ws ON u.id = ws.user_id
LEFT JOIN nutritional_analyses na ON u.id = na.user_id
GROUP BY u.id, u.name, u.email;

-- ============================================
-- DATOS DE PRUEBA (OPCIONAL - Comentar si no se necesita)
-- ============================================

-- Usuario demo
-- INSERT INTO users (id, email, name, phone, height, weight, age, gender, location)
-- VALUES (
--   '00000000-0000-0000-0000-000000000001',
--   'demo@vivofit.com',
--   'Usuario Demo',
--   '+58 412-1234567',
--   175,
--   75,
--   30,
--   'male',
--   'Caracas, Venezuela'
-- );

-- ============================================
-- COMENTARIOS
-- ============================================

COMMENT ON TABLE users IS 'Tabla principal de usuarios de la aplicación';
COMMENT ON TABLE workout_sessions IS 'Registro de sesiones de entrenamiento completadas';
COMMENT ON TABLE nutritional_analyses IS 'Análisis nutricionales realizados con IA (Gemini)';
COMMENT ON TABLE bmi_history IS 'Historial de mediciones de IMC del usuario';
COMMENT ON TABLE memberships IS 'Membresías activas y pasadas de los usuarios';
