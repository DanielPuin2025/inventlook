# 🐳 DEPLOYMENT CON DOCKER - INVENTLOOK
## VPS Hostinger → programamega.com
### ✨ Solo 3 comandos (sin instalar Java, MySQL ni Nginx)

---

## 🎯 VENTAJAS DE DOCKER

- ✅ **No necesitas instalar** Java, MySQL, ni Nginx manualmente
- ✅ **Todo preconfigurado** en contenedores
- ✅ **Solo 3 comandos** para deployment completo
- ✅ **Fácil de actualizar** (rebuild y restart)
- ✅ **Incluye base de datos MySQL** persistente
- ✅ **Incluye Nginx** como proxy reverso
- ✅ **Reinicio automático** si se cae

---

## 📦 ARCHIVOS DOCKER CREADOS

- **[Dockerfile](Dockerfile)** - Imagen de la aplicación Spring Boot
- **[docker-compose.yml](docker-compose.yml)** - Orquestación de servicios
- **[nginx.conf](nginx.conf)** - Configuración del proxy
- **[.env.example](.env.example)** - Ejemplo de variables de entorno

---

## 🚀 PASO 1: PREPARAR EL VPS

### 1.1 Acceder al panel Hostinger

1. Ve a: https://hpanel.hostinger.com
2. Selecciona tu VPS
3. Abre el **Terminal Web** (SSH desde el navegador)

### 1.2 Instalar Docker (solo la primera vez)

Copia y pega estos comandos en la terminal:

```bash
# Actualizar sistema
apt update && apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
apt install docker-compose -y

# Verificar instalación
docker --version
docker-compose --version
```

Debe mostrar las versiones instaladas.

---

## 📁 PASO 2: SUBIR ARCHIVOS AL VPS

### Opción A: Usando File Manager del panel Hostinger

1. **En tu PC:** Comprime la carpeta `inventlook (1)` en ZIP
2. **En hPanel:** 
   - Abre **File Manager**
   - Ve a `/root/`
   - Sube el archivo ZIP
   - Click derecho → **Extract**
   - Renombra la carpeta a `inventlook`

### Opción B: Usando Git (si tienes repositorio)

```bash
cd /root
git clone https://github.com/TU_USUARIO/inventlook.git
cd inventlook
```

---

## ⚙️ PASO 3: CONFIGURAR VARIABLES DE ENTORNO

### En la terminal web del VPS:

```bash
cd /root/inventlook

# Crear archivo .env desde el ejemplo
cp .env.example .env

# Editar el archivo
nano .env
```

Actualiza con tus contraseñas:

```bash
DB_ROOT_PASSWORD=Root#12345
DB_PASSWORD=inventlook2024
MAIL_PASSWORD=tu_password_gmail_real
```

**Guardar:** `Ctrl+O`, Enter, `Ctrl+X`

---

## 🐳 PASO 4: COMPILAR Y EJECUTAR (SOLO 3 COMANDOS)

### En la terminal web:

```bash
cd /root/inventlook

# 1️⃣ Compilar el JAR
./mvnw clean package -DskipTests

# 2️⃣ Construir las imágenes Docker
docker-compose build

# 3️⃣ Iniciar todos los servicios
docker-compose up -d
```

**¡Eso es todo!** 🎉

---

## ✅ VERIFICAR QUE ESTÁ FUNCIONANDO

### Ver el estado de los contenedores:

```bash
docker-compose ps
```

Debe mostrar 3 servicios corriendo:
- `inventlook-mysql` (base de datos)
- `inventlook-app` (aplicación Spring Boot)
- `inventlook-nginx` (proxy web)

### Ver logs en tiempo real:

```bash
# Ver todos los logs
docker-compose logs -f

# Ver solo logs de la aplicación
docker-compose logs -f app

# Ver solo logs de MySQL
docker-compose logs -f mysql
```

Para salir de los logs: `Ctrl+C`

### Probar localmente en el VPS:

```bash
curl http://localhost
```

Debe devolver HTML de tu aplicación.

---

## 🌐 PASO 5: CONFIGURAR DOMINIO

### 5.1 Configurar DNS en Hostinger

1. En el panel Hostinger, ve a **Dominios → programamega.com → DNS**
2. Agrega estos registros:

```
Tipo: A
Nombre: @
Valor: [IP_DE_TU_VPS]
TTL: 3600

Tipo: A
Nombre: www
Valor: [IP_DE_TU_VPS]
TTL: 3600
```

### 5.2 Ver la IP de tu VPS:

```bash
curl ifconfig.me
```

### 5.3 Esperar propagación DNS (5-30 minutos)

Verificar en: https://dnschecker.org

Buscar: `programamega.com`

---

## 🔒 PASO 6: CERTIFICADO SSL (HTTPS)

### 6.1 Instalar Certbot en el VPS:

```bash
apt install certbot -y
```

### 6.2 Detener Nginx temporalmente:

```bash
docker-compose stop nginx
```

### 6.3 Obtener certificado:

```bash
certbot certonly --standalone -d programamega.com -d www.programamega.com
```

Seguir las instrucciones:
1. Ingresar tu **email**
2. Aceptar términos: **Y**

Los certificados se guardan en: `/etc/letsencrypt/live/programamega.com/`

### 6.4 Copiar certificados a carpeta del proyecto:

```bash
mkdir -p /root/inventlook/ssl
cp /etc/letsencrypt/live/programamega.com/fullchain.pem /root/inventlook/ssl/
cp /etc/letsencrypt/live/programamega.com/privkey.pem /root/inventlook/ssl/
```

### 6.5 Editar nginx.conf para habilitar HTTPS:

```bash
cd /root/inventlook
nano nginx.conf
```

**Descomentar** las líneas de SSL (quitar los `#` de las líneas 23-42)

**Guardar:** `Ctrl+O`, Enter, `Ctrl+X`

### 6.6 Reiniciar servicios:

```bash
docker-compose up -d
```

---

## 🔥 PASO 7: CONFIGURAR FIREWALL

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
```

Confirmar con **Y**

---

## 🎉 ¡LISTO!

Tu aplicación está disponible en:
- **HTTP:** http://programamega.com
- **HTTPS:** https://programamega.com

---

## 📝 COMANDOS ÚTILES

### Ver estado de servicios:
```bash
docker-compose ps
```

### Ver logs:
```bash
docker-compose logs -f app
```

### Reiniciar aplicación:
```bash
docker-compose restart app
```

### Reiniciar todo:
```bash
docker-compose restart
```

### Detener todo:
```bash
docker-compose down
```

### Iniciar todo:
```bash
docker-compose up -d
```

### Ver recursos usados:
```bash
docker stats
```

---

## 🔄 ACTUALIZAR LA APLICACIÓN

Cuando hagas cambios al código:

```bash
cd /root/inventlook

# 1. Bajar los contenedores
docker-compose down

# 2. Compilar nuevo JAR
./mvnw clean package -DskipTests

# 3. Reconstruir imagen
docker-compose build app

# 4. Iniciar de nuevo
docker-compose up -d
```

---

## ❌ TROUBLESHOOTING

### Si un contenedor no inicia:

```bash
# Ver logs del contenedor problemático
docker-compose logs mysql
docker-compose logs app
docker-compose logs nginx

# Reiniciar un servicio específico
docker-compose restart app
```

### Si MySQL no se conecta:

```bash
# Verificar que MySQL esté healthy
docker-compose ps

# Ver logs de MySQL
docker-compose logs mysql

# Entrar al contenedor de MySQL
docker exec -it inventlook-mysql mysql -u root -p
```

### Si el dominio no carga:

1. Verificar DNS: https://dnschecker.org
2. Verificar IP del VPS: `curl ifconfig.me`
3. Verificar Nginx: `docker-compose logs nginx`
4. Probar localmente: `curl http://localhost`

### Limpiar y empezar de cero:

```bash
# CUIDADO: Esto borra la base de datos
docker-compose down -v
docker-compose up -d
```

---

## 💾 BACKUP DE LA BASE DE DATOS

### Crear backup:

```bash
docker exec inventlook-mysql mysqldump -u root -p"Root#12345" inventlook > backup_$(date +%Y%m%d).sql
```

### Restaurar backup:

```bash
docker exec -i inventlook-mysql mysql -u root -p"Root#12345" inventlook < backup_20260919.sql
```

---

## 🔄 AUTO-RENOVACIÓN DE SSL

### Crear script de renovación:

```bash
nano /root/renew-ssl.sh
```

Contenido:

```bash
#!/bin/bash
docker-compose stop nginx
certbot renew
cp /etc/letsencrypt/live/programamega.com/fullchain.pem /root/inventlook/ssl/
cp /etc/letsencrypt/live/programamega.com/privkey.pem /root/inventlook/ssl/
docker-compose start nginx
```

Dar permisos:

```bash
chmod +x /root/renew-ssl.sh
```

Agregar a crontab (ejecutar cada 3 meses):

```bash
crontab -e
```

Agregar esta línea:

```
0 3 1 */3 * /root/renew-ssl.sh
```

---

## 📊 MONITOREO

### Ver uso de recursos:

```bash
docker stats
```

### Ver espacio en disco:

```bash
df -h
docker system df
```

### Limpiar imágenes viejas:

```bash
docker system prune -a
```

---

## 🎯 RESUMEN DE COMANDOS PRINCIPALES

```bash
# Iniciar todo
docker-compose up -d

# Detener todo
docker-compose down

# Ver logs
docker-compose logs -f

# Reiniciar aplicación
docker-compose restart app

# Ver estado
docker-compose ps

# Actualizar aplicación
./mvnw clean package -DskipTests && docker-compose up -d --build app
```

---

## 🆘 SOPORTE

Si algo no funciona:

1. Ver logs: `docker-compose logs -f`
2. Verificar estado: `docker-compose ps`
3. Probar localmente: `curl http://localhost`
4. Verificar DNS: https://dnschecker.org

---

## ✅ CHECKLIST FINAL

- [ ] Docker instalado
- [ ] Archivos subidos al VPS
- [ ] `.env` configurado con contraseñas
- [ ] `docker-compose up -d` ejecutado exitosamente
- [ ] 3 contenedores corriendo (mysql, app, nginx)
- [ ] DNS configurado (registros A)
- [ ] Dominio carga en el navegador
- [ ] Certificado SSL instalado
- [ ] HTTPS funcionando
- [ ] Firewall configurado

¡Tu aplicación está lista para producción! 🚀
