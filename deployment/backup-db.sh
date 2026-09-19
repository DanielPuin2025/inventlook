#!/bin/bash

# ===================================================
# Script de Backup de Base de Datos - InventLook
# ===================================================
# Uso: ./backup-db.sh

set -e

echo "========================================="
echo "   Backup de Base de Datos"
echo "========================================="
echo ""

# Variables
BACKUP_DIR="/opt/inventlook/backups"
DB_NAME="inventlook"
DB_USER="inventlook"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/inventlook-backup-$DATE.sql"

# Crear directorio de backups si no existe
mkdir -p "$BACKUP_DIR"

# Cargar password desde .env
if [ -f "/opt/inventlook/.env" ]; then
    export $(cat /opt/inventlook/.env | grep DB_PASSWORD | xargs)
else
    echo "Error: No se encontró archivo .env"
    exit 1
fi

# Realizar backup
echo "Creando backup de la base de datos..."
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✓ Backup creado exitosamente: $BACKUP_FILE"

    # Comprimir el backup
    gzip "$BACKUP_FILE"
    echo "✓ Backup comprimido: $BACKUP_FILE.gz"

    # Mostrar tamaño
    SIZE=$(du -h "$BACKUP_FILE.gz" | cut -f1)
    echo "✓ Tamaño: $SIZE"
else
    echo "✗ Error al crear el backup"
    exit 1
fi

# Eliminar backups antiguos (mantener últimos 7 días)
echo ""
echo "Limpiando backups antiguos (más de 7 días)..."
find "$BACKUP_DIR" -name "inventlook-backup-*.sql.gz" -mtime +7 -delete
echo "✓ Limpieza completada"

# Listar backups disponibles
echo ""
echo "Backups disponibles:"
ls -lh "$BACKUP_DIR" | grep "inventlook-backup"

echo ""
echo "========================================="
echo "   Backup Completado"
echo "========================================="
