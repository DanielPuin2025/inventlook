#!/bin/bash

# ===================================================
# Script de Despliegue - InventLook
# ===================================================
# Este script automatiza el despliegue en el VPS
# Uso: ./deploy.sh

set -e  # Salir si hay algún error

echo "========================================="
echo "   Despliegue de InventLook - Inicio"
echo "========================================="
echo ""

# Variables
APP_DIR="/opt/inventlook"
DB_NAME="inventlook"
DB_USER="inventlook"
JAR_NAME="inventlook-0.0.1-SNAPSHOT.jar"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para imprimir con color
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# 1. Verificar que estamos en el directorio correcto
if [ ! -f "pom.xml" ]; then
    print_error "No se encontró pom.xml. ¿Estás en el directorio correcto?"
    exit 1
fi

print_status "Directorio correcto verificado"

# 2. Verificar que exista .env
if [ ! -f ".env" ]; then
    print_error "No se encontró archivo .env"
    echo "Crea el archivo .env con:"
    echo "  DB_PASSWORD=tu_password"
    echo "  MAIL_USERNAME=tu_correo@gmail.com"
    echo "  MAIL_PASSWORD=tu_password_app"
    exit 1
fi

print_status "Archivo .env encontrado"

# 3. Cargar variables de entorno
export $(cat .env | xargs)
print_status "Variables de entorno cargadas"

# 4. Verificar conexión a base de datos
echo ""
echo "Verificando conexión a MySQL..."
if mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME;" 2>/dev/null; then
    print_status "Conexión a base de datos exitosa"
else
    print_error "No se pudo conectar a la base de datos"
    echo "Verifica las credenciales en .env"
    exit 1
fi

# 5. Detener aplicación si está corriendo
echo ""
echo "Deteniendo aplicación actual..."
if systemctl is-active --quiet inventlook; then
    sudo systemctl stop inventlook
    print_status "Aplicación detenida"
else
    print_warning "La aplicación no estaba corriendo"
fi

# 6. Hacer backup del JAR anterior (si existe)
if [ -f "target/$JAR_NAME" ]; then
    BACKUP_NAME="inventlook-backup-$(date +%Y%m%d-%H%M%S).jar"
    cp "target/$JAR_NAME" "target/$BACKUP_NAME"
    print_status "Backup del JAR anterior creado: $BACKUP_NAME"
fi

# 7. Compilar aplicación
echo ""
echo "Compilando aplicación..."
./mvnw clean package -DskipTests

if [ $? -eq 0 ]; then
    print_status "Compilación exitosa"
else
    print_error "Error en la compilación"
    exit 1
fi

# 8. Verificar que se creó el JAR
if [ ! -f "target/$JAR_NAME" ]; then
    print_error "No se encontró el JAR compilado"
    exit 1
fi

print_status "JAR creado: target/$JAR_NAME"

# 9. Iniciar aplicación
echo ""
echo "Iniciando aplicación..."
sudo systemctl start inventlook

# Esperar un momento para que inicie
sleep 5

# 10. Verificar estado
if systemctl is-active --quiet inventlook; then
    print_status "Aplicación iniciada correctamente"
else
    print_error "La aplicación no se inició correctamente"
    echo "Ver logs con: sudo journalctl -u inventlook -n 50"
    exit 1
fi

# 11. Verificar que responda en el puerto 8080
echo ""
echo "Verificando que la aplicación responda..."
sleep 3

if curl -s http://localhost:8080 > /dev/null; then
    print_status "Aplicación respondiendo en puerto 8080"
else
    print_warning "La aplicación no responde aún (puede tardar unos segundos más)"
fi

# 12. Mostrar estado de servicios
echo ""
echo "========================================="
echo "   Estado de Servicios"
echo "========================================="
echo ""

echo "InventLook:"
sudo systemctl status inventlook --no-pager -l | head -10

echo ""
echo "Nginx:"
sudo systemctl status nginx --no-pager -l | head -5

# 13. Resumen final
echo ""
echo "========================================="
echo "   Despliegue Completado"
echo "========================================="
echo ""
echo "✓ Aplicación compilada"
echo "✓ Aplicación iniciada"
echo "✓ Servicios verificados"
echo ""
echo "Accede a tu aplicación en:"
echo "  - Local: http://localhost:8080"
echo "  - Público: https://programamega.com"
echo ""
echo "Comandos útiles:"
echo "  Ver logs: sudo journalctl -u inventlook -f"
echo "  Reiniciar: sudo systemctl restart inventlook"
echo "  Estado: sudo systemctl status inventlook"
echo ""
