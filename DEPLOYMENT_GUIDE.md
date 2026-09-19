# 🚀 GUÍA DE DEPLOYMENT - INVENTLOOK
## VPS Hostinger → programamega.com

---

## 📋 REQUISITOS EN EL VPS

Antes de empezar, tu VPS debe tener instalado:

1. **Java 17 o superior**
2. **MySQL 8.x**
3. **Maven** (opcional, usaremos el Maven wrapper incluido)
4. **Nginx** (para proxy reverso)

---

## 🔧 PASO 1: PREPARAR EL VPS

### 1.1 Conectarse al VPS por SSH

```bash
ssh root@tu-ip-vps-hostinger
```

### 1.2 Instalar Java 17

```bash
# Actualizar sistema
apt update && apt upgrade -y

# Instalar Java 17
apt install openjdk-17-jdk -y

# Verificar instalación
java -version
```

### 1.3 Instalar MySQL

```bash
# Instalar MySQL
apt install mysql-server -y

# Iniciar MySQL
systemctl start mysql
systemctl enable mysql

# Configurar MySQL (crear contraseña root)
mysql_secure_installation
```

### 1.4 Instalar Nginx

```bash
apt install nginx -y
systemctl start nginx
systemctl enable nginx
```

---

## 📦 PASO 2: SUBIR EL PROYECTO AL VPS

### Opción A: Usando SCP (desde tu PC Windows)

```bash
# Crear carpeta en el VPS
ssh root@tu-ip-vps "mkdir -p /root/inventlook"

# Subir proyecto (ejecutar desde tu carpeta del proyecto)
scp -r * root@tu-ip-vps:/root/inventlook/
```

### Opción B: Usando Git (recomendado)

```bash
# En el VPS
cd /root
git clone https://github.com/TU_USUARIO/inventlook.git
cd inventlook
```

---

## 🗄️ PASO 3: CONFIGURAR MYSQL EN EL VPS

### 3.1 Crear base de datos

```bash
# Conectar a MySQL
mysql -u root -p

# Ejecutar en MySQL:
CREATE DATABASE inventlook CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'inventlook'@'localhost' IDENTIFIED BY 'PasswordSeguro123!';
GRANT ALL PRIVILEGES ON inventlook.* TO 'inventlook'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3.2 Importar tus datos (si tienes backup)

```bash
mysql -u root -p inventlook < tu_backup.sql
```

---

## ⚙️ PASO 4: CONFIGURAR VARIABLES DE ENTORNO

### 4.1 Editar application-prod.properties

```bash
cd /root/inventlook
nano src/main/resources/application-prod.properties
```

Actualizar:
```properties
spring.datasource.password=PasswordSeguro123!
spring.mail.password=TuPasswordGmail
```

---

## 🚀 PASO 5: COMPILAR Y EJECUTAR

### 5.1 Dar permisos de ejecución

```bash
chmod +x mvnw
chmod +x deploy.sh
```

### 5.2 Ejecutar deployment

```bash
./deploy.sh
```

Este script:
- Compila el proyecto
- Crea el archivo JAR
- Inicia la aplicación en puerto 8080
- Guarda logs en `logs/app.log`

---

## 🔄 PASO 6: CONFIGURAR SYSTEMD (REINICIO AUTOMÁTICO)

### 6.1 Copiar archivo de servicio

```bash
# Editar el archivo inventlook.service y actualizar las contraseñas
nano inventlook.service

# Copiar a systemd
cp inventlook.service /etc/systemd/system/

# Recargar systemd
systemctl daemon-reload

# Habilitar servicio
systemctl enable inventlook

# Iniciar servicio
systemctl start inventlook

# Ver estado
systemctl status inventlook
```

### 6.2 Comandos útiles

```bash
# Ver logs en tiempo real
journalctl -u inventlook -f

# Reiniciar aplicación
systemctl restart inventlook

# Detener aplicación
systemctl stop inventlook
```

---

## 🌐 PASO 7: CONFIGURAR NGINX Y DOMINIO

### 7.1 Configurar Nginx como proxy reverso

```bash
nano /etc/nginx/sites-available/inventlook
```

Contenido:
```nginx
server {
    listen 80;
    server_name programamega.com www.programamega.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 7.2 Activar configuración

```bash
# Crear enlace simbólico
ln -s /etc/nginx/sites-available/inventlook /etc/nginx/sites-enabled/

# Verificar configuración
nginx -t

# Reiniciar Nginx
systemctl restart nginx
```

---

## 🔒 PASO 8: CONFIGURAR HTTPS CON CERTBOT

### 8.1 Instalar Certbot

```bash
apt install certbot python3-certbot-nginx -y
```

### 8.2 Obtener certificado SSL

```bash
certbot --nginx -d programamega.com -d www.programamega.com
```

Seguir las instrucciones y proporcionar tu email.

---

## 📡 PASO 9: CONFIGURAR DNS EN HOSTINGER

### 9.1 En el panel de Hostinger:

1. Ve a **Dominios → programamega.com → DNS**
2. Agrega/edita estos registros:

```
Tipo: A
Nombre: @
Valor: IP_DE_TU_VPS
TTL: 3600

Tipo: A
Nombre: www
Valor: IP_DE_TU_VPS
TTL: 3600
```

### 9.2 Esperar propagación DNS (5-30 minutos)

---

## ✅ VERIFICACIÓN FINAL

### Verificar que todo funciona:

```bash
# 1. Aplicación corriendo
systemctl status inventlook

# 2. Nginx corriendo
systemctl status nginx

# 3. Base de datos corriendo
systemctl status mysql

# 4. Probar localmente en el VPS
curl http://localhost:8080

# 5. Probar desde internet
curl http://programamega.com
```

### Abrir en navegador:

- **HTTP:** http://programamega.com
- **HTTPS:** https://programamega.com (después de configurar Certbot)

---

## 🔥 FIREWALL (SEGURIDAD)

```bash
# Instalar UFW
apt install ufw -y

# Permitir SSH
ufw allow 22/tcp

# Permitir HTTP y HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Activar firewall
ufw enable

# Ver estado
ufw status
```

---

## 📝 TROUBLESHOOTING

### Ver logs de la aplicación:
```bash
tail -f /root/inventlook/logs/app.log
journalctl -u inventlook -n 100
```

### Reiniciar todo:
```bash
systemctl restart inventlook
systemctl restart nginx
systemctl restart mysql
```

### Verificar puertos:
```bash
netstat -tulpn | grep :8080
netstat -tulpn | grep :80
```

---

## 🎉 ¡LISTO!

Tu aplicación estará disponible en:
- **http://programamega.com**
- **https://programamega.com** (con SSL)

**Credenciales de prueba:**
- Teléfono: 3001234567
- Contraseña: admin123
