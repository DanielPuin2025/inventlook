# 🚀 Guía Completa de Despliegue - InventLook

## 📋 PARTE 1: PRUEBAS LOCALES

### 1.1 Probar en desarrollo (H2 - sin MySQL)

```bash
# 1. Cambiar el perfil activo a dev
# Edita src/main/resources/application.properties:
spring.profiles.active=dev

# 2. Compilar y ejecutar
./mvnw clean package -DskipTests
./mvnw spring-boot:run

# 3. Acceder a:
# - Aplicación: http://localhost:8080
# - Consola H2: http://localhost:8080/h2-console
```

### 1.2 Probar con MySQL local

```bash
# 1. Crear la base de datos
mysql -u root -p
CREATE DATABASE inventlook CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'inventlook'@'localhost' IDENTIFIED BY 'inventlook2024';
GRANT ALL PRIVILEGES ON inventlook.* TO 'inventlook'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 2. Importar el esquema
mysql -u inventlook -p inventlook < inventlook.sql

# 3. Cambiar a perfil prod
# Edita src/main/resources/application.properties:
spring.profiles.active=prod

# 4. Ejecutar
./mvnw spring-boot:run
```

---

## 🔒 PARTE 2: PREPARAR PARA GITHUB

### 2.1 Proteger credenciales sensibles

Primero, vamos a sacar las credenciales del código:

**Crear archivo de variables de entorno** (NO subir a GitHub):

```bash
# Crear archivo .env (ya está en .gitignore)
echo "DB_PASSWORD=inventlook2024" > .env
echo "MAIL_USERNAME=noireliteofficial@gmail.com" >> .env
echo "MAIL_PASSWORD=lxdugwluolrhfqlp" >> .env
```

**Modificar application-prod.properties para usar variables:**

```properties
spring.datasource.password=${DB_PASSWORD:inventlook2024}
spring.mail.username=${MAIL_USERNAME}
spring.mail.password=${MAIL_PASSWORD}
```

### 2.2 Verificar .gitignore

Asegúrate que `.gitignore` incluya:
```
.env
application-local.properties
*.log
target/
.claude/
.opencode/
```

### 2.3 Subir a GitHub

```bash
# 1. Inicializar repositorio (si no lo has hecho)
git init
git add .
git commit -m "Initial commit: InventLook inventory system"

# 2. Crear repositorio en GitHub
# Ve a https://github.com/new
# Nombre: inventlook
# Visibilidad: Private (recomendado)

# 3. Conectar y subir
git remote add origin https://github.com/TU-USUARIO/inventlook.git
git branch -M main
git push -u origin main
```

---

## 🖥️ PARTE 3: DESPLIEGUE EN VPS HOSTINGER

### 3.1 Requisitos del VPS

- Ubuntu 20.04+ o CentOS 8+
- Mínimo 2GB RAM
- Java 17
- MySQL 8.0
- Nginx (para proxy reverso)

### 3.2 Conexión SSH al VPS

```bash
ssh root@TU_IP_VPS
# O si tienes usuario específico:
ssh usuario@TU_IP_VPS
```

### 3.3 Instalación de dependencias

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Java 17
sudo apt install openjdk-17-jdk -y
java -version

# Instalar MySQL
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql

# Configurar MySQL
sudo mysql_secure_installation
# Responde: Y a todo excepto "Disallow root login remotely" (N)

# Instalar Nginx
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Instalar Git y Maven
sudo apt install git maven -y
```

### 3.4 Configurar MySQL en el VPS

```bash
# Entrar a MySQL
sudo mysql -u root -p

# Crear base de datos y usuario
CREATE DATABASE inventlook CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'inventlook'@'localhost' IDENTIFIED BY 'TU_PASSWORD_SEGURO_AQUI';
GRANT ALL PRIVILEGES ON inventlook.* TO 'inventlook'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3.5 Clonar y configurar aplicación

```bash
# Crear directorio para aplicaciones
sudo mkdir -p /opt/inventlook
sudo chown $USER:$USER /opt/inventlook
cd /opt/inventlook

# Clonar repositorio
git clone https://github.com/TU-USUARIO/inventlook.git .

# Crear archivo de variables de entorno
nano .env
```

**Contenido de .env:**
```bash
DB_PASSWORD=TU_PASSWORD_SEGURO_AQUI
MAIL_USERNAME=tu-correo@gmail.com
MAIL_PASSWORD=tu-contraseña-app-gmail
```

```bash
# Cargar variables de entorno
export $(cat .env | xargs)

# Importar base de datos
mysql -u inventlook -p inventlook < inventlook.sql
```

### 3.6 Compilar aplicación

```bash
# Compilar (sin tests para producción)
./mvnw clean package -DskipTests

# Verificar que se creó el JAR
ls -lh target/*.jar
```

### 3.7 Crear servicio systemd

```bash
sudo nano /etc/systemd/system/inventlook.service
```

**Contenido del archivo:**
```ini
[Unit]
Description=InventLook Inventory Management System
After=network.target mysql.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/inventlook
EnvironmentFile=/opt/inventlook/.env
ExecStart=/usr/bin/java -jar /opt/inventlook/target/inventlook-0.0.1-SNAPSHOT.jar
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=inventlook

[Install]
WantedBy=multi-user.target
```

```bash
# Recargar systemd y habilitar servicio
sudo systemctl daemon-reload
sudo systemctl enable inventlook
sudo systemctl start inventlook

# Verificar estado
sudo systemctl status inventlook

# Ver logs
sudo journalctl -u inventlook -f
```

### 3.8 Configurar Nginx como proxy reverso

```bash
sudo nano /etc/nginx/sites-available/inventlook
```

**Contenido del archivo:**
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
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

```bash
# Habilitar sitio
sudo ln -s /etc/nginx/sites-available/inventlook /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## 🌐 PARTE 4: CONFIGURAR DOMINIO

### 4.1 En Hostinger DNS

1. Ve al panel de Hostinger
2. Selecciona tu dominio `programamega.com`
3. Ve a "DNS Zone"
4. Agrega/modifica estos registros:

```
Tipo    Nombre    Valor                TTL
A       @         TU_IP_VPS           3600
A       www       TU_IP_VPS           3600
```

5. Guarda los cambios (propagación: 5-30 minutos)

### 4.2 Verificar propagación

```bash
# Desde tu computadora local
ping programamega.com
nslookup programamega.com
```

### 4.3 Instalar SSL con Let's Encrypt

```bash
# En el VPS
sudo apt install certbot python3-certbot-nginx -y

# Obtener certificado
sudo certbot --nginx -d programamega.com -d www.programamega.com

# Seguir las instrucciones:
# - Email: tu-correo@email.com
# - Aceptar términos: Y
# - Compartir email: N o Y
# - Redirect HTTP a HTTPS: 2 (recomendado)

# Renovación automática (ya está configurada)
sudo systemctl status certbot.timer
```

### 4.4 Verificar aplicación

```bash
# Espera 5-10 minutos y accede a:
https://programamega.com
```

---

## 🔄 ACTUALIZACIONES FUTURAS

```bash
# En el VPS
cd /opt/inventlook

# 1. Detener aplicación
sudo systemctl stop inventlook

# 2. Actualizar código
git pull origin main

# 3. Recompilar
./mvnw clean package -DskipTests

# 4. Reiniciar
sudo systemctl start inventlook
sudo systemctl status inventlook
```

---

## 🐛 TROUBLESHOOTING

### Ver logs de la aplicación
```bash
sudo journalctl -u inventlook -n 100 --no-pager
sudo journalctl -u inventlook -f
```

### Ver logs de Nginx
```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

### Reiniciar servicios
```bash
sudo systemctl restart inventlook
sudo systemctl restart nginx
sudo systemctl restart mysql
```

### Verificar puertos
```bash
sudo netstat -tulpn | grep :8080
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
```

### Firewall
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw enable
sudo ufw status
```
