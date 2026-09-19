# 🚀 DEPLOYMENT CON GITHUB + DOCKER
## Guía completa para subir InventLook a GitHub y desplegarlo en Hostinger VPS

---

## 📋 PASO 1: CREAR REPOSITORIO EN GITHUB

### 1.1 Crear nuevo repositorio

1. Ve a: https://github.com/new
2. **Repository name:** `inventlook`
3. **Description:** "Sistema de gestión de inventario con Spring Boot"
4. **Visibilidad:** 
   - ✅ **Private** (recomendado para proyectos con datos sensibles)
   - ⚠️ Public (solo si no te importa que sea público)
5. **NO marcar** "Add README" ni ".gitignore" (ya los tienes)
6. Click **"Create repository"**

### 1.2 Copiar la URL del repositorio

Verás algo como:
```
https://github.com/TU_USUARIO/inventlook.git
```

**¡Guarda esa URL!** La necesitarás en el siguiente paso.

---

## 💻 PASO 2: SUBIR CÓDIGO A GITHUB DESDE TU PC

Abre **Git Bash** o **PowerShell** en tu PC y ejecuta:

```bash
# Ir a la carpeta del proyecto
cd "C:\Users\Daniel_Puin\Desktop\REVISION PROYECTOS\inventlook (1)"

# Ver archivos modificados
git status

# Agregar todos los archivos
git add .

# Crear commit
git commit -m "Add Docker deployment configuration

- Add Dockerfile for Spring Boot app
- Add docker-compose.yml with MySQL and Nginx
- Add nginx.conf for reverse proxy
- Add deployment guides (Docker and hPanel)
- Update .gitignore to exclude sensitive files
- Update application-prod.properties to use env variables

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>"

# Cambiar a rama main (si estás en master)
git branch -M main

# Conectar con GitHub (reemplaza TU_USUARIO con tu usuario real)
git remote add origin https://github.com/TU_USUARIO/inventlook.git

# Subir código a GitHub
git push -u origin main
```

Te pedirá tus credenciales de GitHub.

---

## 🔐 PASO 2.1: AUTENTICACIÓN EN GITHUB (SI TE LA PIDE)

GitHub ya no acepta contraseñas normales. Necesitas un **Personal Access Token**:

### Crear token:

1. Ve a: https://github.com/settings/tokens
2. Click **"Generate new token (classic)"**
3. **Note:** "InventLook deployment"
4. **Expiration:** 90 days (o No expiration)
5. **Scopes:** Marca **`repo`** (acceso completo a repositorios)
6. Click **"Generate token"**
7. **¡COPIA EL TOKEN!** (solo se muestra una vez)

### Usar el token:

Cuando `git push` te pida contraseña, pega el **token** en lugar de tu contraseña de GitHub.

---

## ✅ VERIFICAR EN GITHUB

1. Ve a: `https://github.com/TU_USUARIO/inventlook`
2. Debes ver todos tus archivos subidos
3. Verifica que estén:
   - `Dockerfile`
   - `docker-compose.yml`
   - `nginx.conf`
   - `.env.example`
   - Carpeta `src/`
   - `pom.xml`

---

## 🖥️ PASO 3: CLONAR EN EL VPS

### 3.1 Acceder al VPS

1. Panel Hostinger → Tu VPS → **Terminal Web**
2. O desde tu PC: `ssh root@tu-ip-vps`

### 3.2 Instalar Git (si no está instalado)

```bash
apt update
apt install git -y
```

### 3.3 Clonar el repositorio

```bash
cd /root

# Si el repo es PRIVADO:
git clone https://github.com/TU_USUARIO/inventlook.git

# Te pedirá usuario y token (el mismo que usaste antes)
```

**Si el repo es público**, el clone funcionará sin pedir credenciales.

---

## ⚙️ PASO 4: CONFIGURAR VARIABLES DE ENTORNO

```bash
cd /root/inventlook

# Crear archivo .env desde el ejemplo
cp .env.example .env

# Editar con tus contraseñas reales
nano .env
```

**Contenido del archivo `.env`:**

```bash
DB_ROOT_PASSWORD=Root#12345
DB_PASSWORD=inventlook2024
MAIL_PASSWORD=tu_password_gmail_real
```

**Guardar:** `Ctrl+O`, Enter, `Ctrl+X`

---

## 🐳 PASO 5: INSTALAR DOCKER

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

---

## 🚀 PASO 6: COMPILAR Y EJECUTAR

```bash
cd /root/inventlook

# 1️⃣ Compilar el JAR
./mvnw clean package -DskipTests

# 2️⃣ Construir imágenes Docker
docker-compose build

# 3️⃣ Iniciar todos los servicios
docker-compose up -d
```

---

## ✅ PASO 7: VERIFICAR QUE FUNCIONA

```bash
# Ver estado de contenedores
docker-compose ps

# Ver logs
docker-compose logs -f app

# Probar localmente
curl http://localhost
```

Si ves HTML de tu aplicación, **¡funciona!** 🎉

---

## 🌐 PASO 8: CONFIGURAR DOMINIO programamega.com

### 8.1 Configurar DNS

1. Panel Hostinger → **Dominios** → **programamega.com** → **DNS**
2. Agregar estos registros:

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

### 8.2 Ver IP del VPS:

```bash
curl ifconfig.me
```

### 8.3 Esperar propagación (5-30 minutos)

Verificar en: https://dnschecker.org

---

## 🔒 PASO 9: CERTIFICADO SSL (HTTPS)

```bash
# Instalar Certbot
apt install certbot -y

# Detener Nginx temporalmente
docker-compose stop nginx

# Obtener certificado
certbot certonly --standalone -d programamega.com -d www.programamega.com

# Copiar certificados
mkdir -p /root/inventlook/ssl
cp /etc/letsencrypt/live/programamega.com/fullchain.pem /root/inventlook/ssl/
cp /etc/letsencrypt/live/programamega.com/privkey.pem /root/inventlook/ssl/

# Editar nginx.conf para habilitar HTTPS
nano nginx.conf
# Descomentar las líneas 23-42 (quitar los #)

# Reiniciar servicios
docker-compose up -d
```

---

## 🔥 PASO 10: CONFIGURAR FIREWALL

```bash
apt install ufw -y
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

---

## 🎉 ¡LISTO!

Tu aplicación está disponible en:
- **HTTP:** http://programamega.com
- **HTTPS:** https://programamega.com

---

## 🔄 ACTUALIZAR LA APLICACIÓN

Cuando hagas cambios en el código:

### Desde tu PC:

```bash
cd "C:\Users\Daniel_Puin\Desktop\REVISION PROYECTOS\inventlook (1)"

git add .
git commit -m "Descripción de los cambios"
git push
```

### En el VPS:

```bash
cd /root/inventlook

# Descargar cambios
git pull

# Recompilar y reiniciar
./mvnw clean package -DskipTests
docker-compose up -d --build app
```

---

## 📝 COMANDOS ÚTILES

```bash
# Ver logs en tiempo real
docker-compose logs -f app

# Reiniciar aplicación
docker-compose restart app

# Ver estado
docker-compose ps

# Detener todo
docker-compose down

# Iniciar todo
docker-compose up -d

# Entrar a MySQL
docker exec -it inventlook-mysql mysql -u root -p
```

---

## ✅ CHECKLIST FINAL

- [ ] Repositorio creado en GitHub
- [ ] Código subido con `git push`
- [ ] VPS tiene Git instalado
- [ ] Repositorio clonado en `/root/inventlook`
- [ ] Archivo `.env` configurado con contraseñas
- [ ] Docker instalado
- [ ] `docker-compose up -d` ejecutado
- [ ] 3 contenedores corriendo (mysql, app, nginx)
- [ ] DNS configurado (registros A)
- [ ] Dominio carga en navegador
- [ ] Certificado SSL instalado
- [ ] HTTPS funcionando
- [ ] Firewall configurado

---

## 🆘 TROUBLESHOOTING

### Error: "Permission denied (publickey)"

GitHub rechaza la conexión SSH. Soluciones:

1. Usa HTTPS en lugar de SSH: `https://github.com/TU_USUARIO/inventlook.git`
2. O configura SSH keys (más complejo)

### Error: "git: command not found" en VPS

```bash
apt install git -y
```

### Error al clonar repo privado

Necesitas autenticarte con token:
- Usuario: tu usuario de GitHub
- Contraseña: el Personal Access Token

### Dominio no carga

1. Verificar DNS: https://dnschecker.org
2. Verificar IP: `curl ifconfig.me`
3. Probar localmente: `curl http://localhost`

---

## 🎯 VENTAJAS DE ESTE MÉTODO

✅ Control de versiones completo  
✅ Fácil actualización (`git pull`)  
✅ Respaldo automático en GitHub  
✅ Colaboración con otros desarrolladores  
✅ Historial de cambios  
✅ Rollback fácil si algo falla  

¡Tu proyecto está ahora en producción y versionado profesionalmente! 🚀
