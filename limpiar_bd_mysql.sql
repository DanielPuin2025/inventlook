-- ELIMINAR TODAS LAS TABLAS DE INVENTLOOK
-- Ejecuta esto en MySQL Workbench para limpiar la base de datos

USE inventlook;

-- Desactivar verificación de foreign keys temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- Eliminar todas las tablas
DROP TABLE IF EXISTS movimientos;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS codigo_recuperacion;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS empresa;

-- Reactivar verificación de foreign keys
SET FOREIGN_KEY_CHECKS = 1;

-- Verificar que están eliminadas
SHOW TABLES;
