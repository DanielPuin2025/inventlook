-- Crear base de datos inventlook si no existe
CREATE DATABASE IF NOT EXISTS inventlook CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Verificar que se creó
SHOW DATABASES LIKE 'inventlook';

-- Usar la base de datos
USE inventlook;

-- Ver las tablas (debería estar vacío si es nueva)
SHOW TABLES;
