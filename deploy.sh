#!/bin/bash
# Script de deployment para VPS Hostinger
# Ejecutar este script en el VPS después de subir el proyecto

echo "🚀 Iniciando deployment de InventLook..."

# Detener la aplicación si está corriendo
echo "⏹️  Deteniendo aplicación existente..."
pkill -f inventlook || true

# Compilar el proyecto
echo "🔨 Compilando proyecto..."
./mvnw clean package -DskipTests

# Verificar que el JAR se creó
if [ ! -f "target/inventlook-0.0.1-SNAPSHOT.jar" ]; then
    echo "❌ Error: No se pudo crear el JAR"
    exit 1
fi

echo "✅ Compilación exitosa"

# Crear directorio para logs si no existe
mkdir -p logs

# Iniciar la aplicación en segundo plano
echo "▶️  Iniciando aplicación..."
nohup java -jar target/inventlook-0.0.1-SNAPSHOT.jar \
    --spring.profiles.active=prod \
    > logs/app.log 2>&1 &

echo "⏳ Esperando que la aplicación inicie..."
sleep 10

# Verificar que está corriendo
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ InventLook está corriendo en http://localhost:8080"
else
    echo "❌ Error: La aplicación no responde"
    echo "Ver logs en: logs/app.log"
    exit 1
fi

echo "🎉 Deployment completado exitosamente"
