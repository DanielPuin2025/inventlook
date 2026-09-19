# 🚀 GUÍA DE DEPLOYMENT - INVENTLOOK (PANEL HOSTINGER)
## VPS Hostinger → programamega.com
### ✨ Usando hPanel (interfaz web) + mínima consola

---

## 📋 ARCHIVOS A SUBIR

Estos son los archivos que subirás al VPS:

```
inventlook/
├── src/                          (toda la carpeta)
├── target/
│   └── inventlook-0.0.1-SNAPSHOT.jar   ⭐ (archivo principal)
├── mvnw                          (Maven wrapper)
├── mvnw.cmd
├── pom.xml                       (configuración Maven)
├── deploy.sh                     (script de deployment)
└── inventlook.service            (servicio systemd)
```

---

## 🎯 PASO 1: ACCEDER AL PANEL HOSTINGER

1. **Ir a:** https://hpanel.hostinger.com
2. **Iniciar sesión** con tu cuenta Hostinger
3. **Seleccionar tu VPS** en la lista de servicios

---

## 📁 PASO 2: SUBIR ARCHIVOS AL VPS

### 2.1 Abrir el Administrador de Archivos

1. En el panel del VPS, busca **"File Manager"** o **"Administrador de archivos"**
2. Navega a `/root/`
3. Crea carpeta `inventlook`

### 2.2 Subir los archivos

**Opción A: Subir carpeta completa comprimida**

1. **En tu PC:** Comprime la carpeta del proyecto en ZIP
   - Selecciona toda la carpeta `inventlook (1)`
   - Click derecho → Comprimir → ZIP
   - Nombre: `inventlook.zip`

2. **En hPanel:** 
   - Ve a `/root/`
   - Click en **"Upload"** o **"Subir"**
   - Selecciona `inventlook.zip`
   - Espera que termine
   - Click derecho en el ZIP → **"Extract"** o **"Extraer"**

**Opción B: Subir archivos individuales**

Si el ZIP es muy grande, sube solo lo esencial:
1. **JAR principal:** `target/inventlook-0.0.1-SNAPSHOT.jar`
2. **Scripts:** `deploy.sh`, `inventlook.service`
3. **Carpeta src completa**
4. **Archivos:** `mvnw`, `pom.xml`

---

## 🗄️ PASO 3: CONFIGURAR MYSQL (DESDE hPanel)

### 3.1 Crear base de datos

1. En el panel VPS, busca **"Databases"** o **"phpMyAdmin"**
2. Abre **phpMyAdmin**
3. Click en **"Nueva base de datos"**
   - Nombre: `inventlook`
   - Cotejamiento: `utf8mb4_unicode_ci`
   - Click **"Crear"**

### 3.2 Crear usuario MySQL

En phpMyAdmin, pestaña **SQL**, ejecuta:

```sql
CREATE USER 'inventlook'@'localhost' IDENTIFIED BY 'Password123!';
GRANT ALL PRIVILEGES ON inventlook.* TO 'inventlook'@'localhost';
FLUSH PRIVILEGES;
```

### 3.3 Importar tus datos (si tienes backup)

1. Selecciona base de datos `inventlook`
2. Click en **"Importar"**
3. Selecciona tu archivo `.sql`
4. Click **"Continuar"**

---

## 🔧 PASO 4: CONFIGURAR VARIABLES (EDITAR ARCHIVO)

### 4.1 Editar application-prod.properties

1. En el File Manager, navega a:
   ```
   /root/inventlook/src/main/resources/application-prod.properties
   ```

2. Click derecho → **"Edit"** o **"Editar"**

3. Actualizar estas líneas:
   ```properties
   spring.datasource.password=Password123!
   spring.mail.password=TuPasswordGmail
   ```

4. **Guardar** (Save)

---

## 💻 PASO 5: TERMINAL WEB (SOLO 5 COMANDOS)

### 5.1 Abrir terminal

En el panel del VPS, busca **"Terminal"** o **"SSH Access"** o **"Web SSH"**

Se abrirá una terminal en el navegador (no necesitas programas externos).

### 5.2 Instalar Java 17 (si no está instalado)

```bash
apt update && apt install openjdk-17-jdk -y
```

Espera 1-2 minutos.

### 5.3 Verificar Java

```bash
java -version
```

Debe decir: `openjdk version "17.x.x"`

### 5.4 Dar permisos y ejecutar deployment

```bash
cd /root/inventlook
chmod +x mvnw deploy.sh
./deploy.sh
```

Espera 1-2 minutos. Debe decir al final:
```
✅ InventLook está corriendo en http://localhost:8080
🎉 Deployment completado exitosamente
```

### 5.5 Verificar que funciona

```bash
curl http://localhost:8080
```

Debe devolver código HTML.

---

## 🔄 PASO 6: CONFIGURAR REINICIO AUTOMÁTICO

### 6.1 En la terminal web, ejecuta:

```bash
# Editar el archivo de servicio y actualizar contraseñas
nano /root/inventlook/inventlook.service
```

Actualiza estas líneas con tus contraseñas reales:
```
Environment="DB_PASSWORD=Password123!"
Environment="MAIL_PASSWORD=TuPasswordGmail"
```

**Guardar:** `Ctrl+O`, Enter, `Ctrl+X`

### 6.2 Instalar servicio

```bash
cp /root/inventlook/inventlook.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable inventlook
systemctl start inventlook
systemctl status inventlook
```

Debe decir: `Active: active (running)`

---

## 🌐 PASO 7: CONFIGURAR NGINX (PROXY)

### 7.1 Instalar Nginx (si no está)

```bash
apt install nginx -y
```

### 7.2 Crear configuración

```bash
nano /etc/nginx/sites-available/inventlook
```

Pega esto:

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

**Guardar:** `Ctrl+O`, Enter, `Ctrl+X`

### 7.3 Activar configuración

```bash
ln -s /etc/nginx/sites-available/inventlook /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

---

## 📡 PASO 8: CONFIGURAR DOMINIO (DESDE hPanel)

### 8.1 En el panel Hostinger:

1. Ve a **"Dominios"**
2. Selecciona **programamega.com**
3. Click en **"DNS / Name Servers"** o **"Zona DNS"**

### 8.2 Agregar/Editar registros DNS:

Busca o crea estos registros:

**Registro 1:**
```
Tipo: A
Nombre: @ (o dejar vacío)
Apunta a: [IP_DE_TU_VPS]
TTL: 3600
```

**Registro 2:**
```
Tipo: A
Nombre: www
Apunta a: [IP_DE_TU_VPS]
TTL: 3600
```

### 8.3 Guardar cambios

Espera **5-30 minutos** para propagación DNS.

---

## 🔒 PASO 9: CERTIFICADO SSL (HTTPS)

### 9.1 En la terminal web:

```bash
apt install certbot python3-certbot-nginx -y
certbot --nginx -d programamega.com -d www.programamega.com
```

### 9.2 Seguir las instrucciones:

1. Ingresar tu **email**
2. Aceptar términos: **Y**
3. Redirigir HTTP a HTTPS: **2** (recomendado)

---

## 🔥 PASO 10: CONFIGURAR FIREWALL

### En la terminal web:

```bash
apt install ufw -y
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

Confirmar con **Y**

---

## ✅ VERIFICACIÓN FINAL

### 10.1 Verificar servicios

```bash
systemctl status inventlook
systemctl status nginx
systemctl status mysql
```

Todos deben estar `active (running)`

### 10.2 Probar desde internet

Abre en tu navegador:
- http://programamega.com
- https://programamega.com

Debe aparecer tu página de login.

---

## 📝 COMANDOS ÚTILES

### Ver logs de la aplicación:
```bash
tail -f /root/inventlook/logs/app.log
journalctl -u inventlook -f
```

### Reiniciar aplicación:
```bash
systemctl restart inventlook
```

### Reiniciar Nginx:
```bash
systemctl restart nginx
```

### Ver IP del VPS:
```bash
curl ifconfig.me
```

---

## ❌ TROUBLESHOOTING

### Si la aplicación no inicia:

```bash
# Ver logs
tail -100 /root/inventlook/logs/app.log

# Verificar que MySQL esté corriendo
systemctl status mysql

# Verificar puerto 8080
netstat -tulpn | grep 8080
```

### Si el dominio no carga:

1. Verificar IP del VPS: `curl ifconfig.me`
2. Verificar DNS: https://dnschecker.org (buscar programamega.com)
3. Verificar Nginx: `systemctl status nginx`

### Si hay error de base de datos:

1. Verificar contraseña en `application-prod.properties`
2. Verificar usuario MySQL en phpMyAdmin
3. Ver logs: `tail -100 /root/inventlook/logs/app.log`

---

## 🎉 ¡LISTO!

Tu aplicación está corriendo en:
- **HTTP:** http://programamega.com
- **HTTPS:** https://programamega.com

**Login de prueba:**
- Teléfono: `3001234567`
- Contraseña: `admin123`

---

## 📞 RESUMEN DE ACCESOS

- **Panel Hostinger:** https://hpanel.hostinger.com
- **Terminal Web:** Desde el panel del VPS
- **phpMyAdmin:** Desde el panel → Databases
- **Aplicación:** https://programamega.com

---

## 🔄 ACTUALIZAR LA APLICACIÓN (FUTURO)

Cuando hagas cambios al código:

1. Compilar JAR localmente: `./mvnw clean package -DskipTests`
2. Subir nuevo JAR al VPS (File Manager)
3. En terminal web: `systemctl restart inventlook`

¡Eso es todo!
