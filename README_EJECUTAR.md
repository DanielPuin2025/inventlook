# 🚀 GUÍA DE EJECUCIÓN - INVENTLOOK

## ✅ Configuración Completada

Tu proyecto ahora tiene **2 perfiles de configuración**:

### 🔧 Perfil DEV (Desarrollo Local - SIN MySQL)
- Base de datos: **H2 en memoria**
- No requiere instalación de MySQL
- Perfecto para desarrollo y pruebas rápidas
- Los datos se pierden al cerrar la aplicación
- **ACTIVO POR DEFECTO**

### 🌐 Perfil PROD (Producción - VPS Hostinger)
- Base de datos: **MySQL**
- Requiere MySQL instalado
- Para despliegue en tu VPS
- Los datos persisten permanentemente

---

## 🎯 CÓMO EJECUTAR EL PROYECTO

### Opción 1: Desde VSCode (MÁS FÁCIL)
1. Abre el archivo: `InventlookApplication (1).java`
2. Presiona **F5** o haz clic en **Run > Start Debugging**
3. Selecciona: **"InventlookApplication"**
4. ¡Listo! La aplicación iniciará en http://localhost:8080

### Opción 2: Desde la Terminal
```bash
# Navega a la carpeta del proyecto
cd "C:\Users\Daniel_Puin\Desktop\REVISION PROYECTOS\inventlook (1)"

# Ejecuta con Maven Wrapper
./mvnw spring-boot:run
```

### Opción 3: Con el script run.bat
```bash
.\run.bat
```

---

## 🔄 CAMBIAR ENTRE PERFILES

### Para Desarrollo Local (H2):
Edita: `src (1)\main (1)\resources (1)\application.properties`
```properties
spring.profiles.active=dev
```

### Para Producción (MySQL):
Edita: `src (1)\main (1)\resources (1)\application.properties`
```properties
spring.profiles.active=prod
```

**IMPORTANTE:** Antes de cambiar a `prod`, debes:
1. Tener MySQL instalado y ejecutándose
2. Crear la base de datos `inventlook`
3. Configurar el password en: `application-prod.properties`

---

## 🗄️ Consola H2 (Solo en modo DEV)

Cuando ejecutes en modo **dev**, puedes acceder a la consola de la base de datos:

- URL: http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:mem:inventlook`
- Usuario: `sa`
- Password: *(dejar en blanco)*

---

## 📦 DESPLIEGUE EN VPS HOSTINGER

### Paso 1: Preparar el VPS
```bash
# Instalar MySQL en el VPS
sudo apt update
sudo apt install mysql-server

# Crear la base de datos
mysql -u root -p
CREATE DATABASE inventlook;
EXIT;
```

### Paso 2: Cambiar a perfil PROD
Edita `application.properties`:
```properties
spring.profiles.active=prod
```

Edita `application-prod.properties` con las credenciales de tu VPS:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/inventlook
spring.datasource.username=tu_usuario_mysql
spring.datasource.password=tu_password_mysql
```

### Paso 3: Compilar el proyecto
```bash
./mvnw clean package -DskipTests
```

Esto generará: `target/inventlook-0.0.1-SNAPSHOT.jar`

### Paso 4: Subir al VPS
```bash
scp target/inventlook-0.0.1-SNAPSHOT.jar usuario@tu-dominio.com:/ruta/destino/
```

### Paso 5: Ejecutar en el VPS
```bash
ssh usuario@tu-dominio.com
cd /ruta/destino/
java -jar inventlook-0.0.1-SNAPSHOT.jar
```

---

## 🛠️ SOLUCIÓN DE PROBLEMAS

### Error: "Cannot load driver class: org.h2.Driver"
**Solución:** Ejecuta primero:
```bash
./mvnw clean install -DskipTests
```

### Error: "Port 8080 already in use"
**Solución:** Cambia el puerto en `application.properties`:
```properties
server.port=8081
```

### La aplicación inicia pero no carga
**Solución:** Verifica que el perfil activo sea correcto en `application.properties`

---

## 📋 CHECKLIST ANTES DE DESPLEGAR

- [ ] Cambié `spring.profiles.active=prod`
- [ ] Configuré las credenciales de MySQL en `application-prod.properties`
- [ ] MySQL está instalado y ejecutándose en el VPS
- [ ] La base de datos `inventlook` existe
- [ ] Compilé el proyecto: `./mvnw clean package -DskipTests`
- [ ] Probé localmente que funciona en modo PROD

---

## 📞 CONTACTO Y SOPORTE

Si tienes problemas:
1. Verifica los logs en la consola
2. Revisa que el perfil activo sea el correcto
3. Asegúrate de que MySQL esté ejecutándose (modo PROD)

**¡Tu proyecto está listo para desarrollar y desplegar!** 🎉
