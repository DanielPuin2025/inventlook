# 📦 Scripts de Despliegue y Mantenimiento

Este directorio contiene scripts útiles para desplegar y mantener la aplicación en el VPS.

## Contenido

- `deploy.sh` - Script principal de despliegue en VPS
- `backup-db.sh` - Script para backup automático de base de datos
- `update-app.sh` - Script para actualizar la aplicación sin downtime

## Uso

### Despliegue inicial

```bash
# En tu VPS
cd /opt/inventlook
chmod +x deployment/*.sh
./deployment/deploy.sh
```

### Backups

```bash
# Ejecutar backup manual
./deployment/backup-db.sh

# Configurar backup automático diario
crontab -e
# Agregar: 0 2 * * * /opt/inventlook/deployment/backup-db.sh
```

### Actualizaciones

```bash
# Actualizar aplicación desde GitHub
./deployment/update-app.sh
```
