-- CREAR USUARIO ADMINISTRADOR PARA INVENTLOOK
USE inventlook;

-- Insertar usuario administrador
-- Teléfono: 3001234567
-- Contraseña: admin123
-- IMPORTANTE: La contraseña NO está encriptada (texto plano)

INSERT INTO usuario (telefono, nombre, correo, contrasena, rol, activo, fecha_registro)
VALUES
('3001234567', 'Administrador', 'admin@inventlook.com', 'admin123', 'ADMIN', true, NOW());

-- Verificar que se creó
SELECT * FROM usuario;
