#!/usr/bin/env bash

# Script de Migración Automática a Supabase
# Este script hace los cambios necesarios en login_screen.dart

echo "🚀 Iniciando migración de Login Screen a Supabase..."

FILE="lib/screens/auth/login_screen.dart"

# Backup del archivo original
cp "$FILE" "${FILE}.backup"
echo "✅ Backup creado: ${FILE}.backup"

# Reemplazos
sed -i 's/import.*auth_service.dart.*/import '\''package:vivofit\/services\/supabase_auth_service.dart'\'';/' "$FILE"
sed -i 's/import.*user_service.dart.*/import '\''package:vivofit\/services\/supabase_user_service.dart'\'';/' "$FILE"
sed -i 's/context.read<AuthService>()/context.read<SupabaseAuthService>()/g' "$FILE"
sed -i 's/context.read<UserService>()/context.read<SupabaseUserService>()/g' "$FILE"
sed -i 's/Consumer<AuthService>/Consumer<SupabaseUserService>/g' "$FILE"

echo "✅ Cambios aplicados en $FILE"
echo ""
echo "📝 Siguientes pasos:"
echo "1. Revisa los cambios en $FILE"
echo "2. Si algo sale mal, restaura: cp ${FILE}.backup $FILE"
echo "3. Ejecuta: flutter run -d chrome"
echo "4. Prueba login con: test@vivofit.com / 123456"
echo ""
echo "✨ Migración completada!"
