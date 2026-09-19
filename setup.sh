#!/bin/bash

# ===================================================
# Script de configuración inicial para InventLook
# ===================================================

echo "🚀 Configuración Inicial de InventLook"
echo "======================================="
echo ""

# Verificar si .env ya existe
if [ -f ".env" ]; then
    echo "⚠️  El archivo .env ya existe."
    read -p "¿Deseas sobrescribirlo? (s/n): " overwrite
    if [ "$overwrite" != "s" ]; then
        echo "Cancelado. Usando .env existente."
        exit 0
    fi
fi

# Crear archivo .env
echo "📝 Creando archivo .env..."
echo ""

# Solicitar datos
read -p "Ingresa la contraseña de MySQL (default: inventlook2024): " db_password
db_password=${db_password:-inventlook2024}

read -p "Ingresa tu correo de Gmail: " mail_username
read -p "Ingresa tu contraseña de aplicación de Gmail: " mail_password

# Crear archivo
cat > .env << EOF
# Base de datos MySQL (Producción)
DB_PASSWORD=$db_password

# Configuración de correo Gmail
MAIL_USERNAME=$mail_username
MAIL_PASSWORD=$mail_password
EOF

echo ""
echo "✅ Archivo .env creado exitosamente"
echo ""
echo "📋 Próximos pasos:"
echo "1. Verifica que .env tenga los datos correctos"
echo "2. Ejecuta: ./mvnw spring-boot:run"
echo "3. Accede a: http://localhost:8080"
echo ""
echo "🔐 IMPORTANTE: .env NO se subirá a GitHub (está en .gitignore)"
