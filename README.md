# 🏢 InventLook - Sistema de Gestión de Inventario

Sistema web profesional de gestión de inventario desarrollado con Spring Boot y MySQL.

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://openjdk.java.net/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.1.0-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-Private-red.svg)](LICENSE)

## 🚀 Características

- ✅ Gestión de productos y categorías
- ✅ Control de movimientos de inventario
- ✅ Sistema de usuarios con roles
- ✅ Alertas de stock bajo
- ✅ Dashboard con estadísticas
- ✅ Recuperación de contraseña por correo

## 🛠️ Tecnologías

- **Backend:** Spring Boot 4.1.0
- **Base de datos:** MySQL 8.0
- **Frontend:** Thymeleaf + HTML/CSS/JavaScript
- **Java:** JDK 17 o superior

## 📋 Requisitos Previos

- ☕ Java JDK 17 o superior
- 🐬 MySQL 8.0 o superior (opcional para desarrollo)
- 📦 Maven 3.6 o superior
- 🌐 Navegador web moderno

## 🚀 Inicio Rápido (Desarrollo)

### Opción 1: Con H2 (sin instalar MySQL)

```bash
# 1. Clonar el repositorio
git clone https://github.com/TU-USUARIO/inventlook.git
cd inventlook

# 2. Configurar variables de entorno
# Windows:
setup.bat

# Linux/Mac:
chmod +x setup.sh
./setup.sh

# 3. Ejecutar (H2 está activo por defecto en perfil dev)
./mvnw spring-boot:run

# 4. Acceder a: http://localhost:8080
```

### Opción 2: Con MySQL Local

```bash
# 1. Crear base de datos
mysql -u root -p
CREATE DATABASE inventlook CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'inventlook'@'localhost' IDENTIFIED BY 'inventlook2024';
GRANT ALL PRIVILEGES ON inventlook.* TO 'inventlook'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 2. Importar datos
mysql -u inventlook -p inventlook < inventlook.sql

# 3. Cambiar a perfil prod en application.properties
spring.profiles.active=prod

# 4. Ejecutar
./mvnw spring-boot:run
```

## 📖 Documentación Completa

- **[QUICKSTART.md](QUICKSTART.md)** - Guía de inicio rápido
- **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Guía completa de pruebas
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Despliegue en VPS y configuración de dominio
- **[SECURITY_RECOMMENDATIONS.md](SECURITY_RECOMMENDATIONS.md)** - Recomendaciones de seguridad

## 🌐 Despliegue en VPS

### Requisitos del VPS:
- Ubuntu 20.04 o superior
- 2GB RAM mínimo
- Java 17
- MySQL 8.0

### Pasos de despliegue:

1. **Instalar dependencias en el VPS:**
   ```bash
   sudo apt update
   sudo apt install openjdk-17-jdk mysql-server git -y
   ```

2. **Clonar el repositorio:**
   ```bash
   cd /opt
   git clone https://github.com/TU-USUARIO/inventlook.git
   cd inventlook
   ```

3. **Crear la base de datos:**
   ```bash
   mysql -u root -p < base_inventlook_completo.sql
   ```

4. **Compilar el proyecto:**
   ```bash
   ./mvnw clean package -DskipTests
   ```

5. **Ejecutar la aplicación:**
   ```bash
   java -jar target/inventlook-0.0.1-SNAPSHOT.jar
   ```

## 🔐 Credenciales por defecto

**IMPORTANTE:** Crea un usuario desde el formulario de registro o inserta uno manualmente:

```sql
INSERT INTO usuario (nombre, correo, contrasena, telefono, activo, rol) 
VALUES ('Admin', 'admin@inventlook.com', '1234567', '3001234567', 1, 'ADMINISTRADOR');
```

- **Teléfono:** 3001234567
- **Contraseña:** 1234567

## 📧 Configuración de correo

Para habilitar la recuperación de contraseña por correo, configura en `application.properties`:

```properties
spring.mail.username=tu-correo@gmail.com
spring.mail.password=tu-contraseña-de-aplicacion
```

## 📝 Licencia

Este proyecto es privado y de uso educativo.

## 👨‍💻 Autor

Desarrollado para gestión de inventario empresarial.
