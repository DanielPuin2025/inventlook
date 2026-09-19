# Guía de Despliegue en VPS Hostinger con Dominio

## 📋 Requisitos previos
- VPS Hostinger con Ubuntu (IP: 2.25.217.236)
- Dominio: www.programamega.com
- MySQL instalado y configurado
- Java 17 instalado
- Git instalado

---

## 🔧 PASO 1: Configurar DNS en Hostinger

1. Inicia sesión en tu panel de Hostinger (hpanel.hostinger.com)
2. Ve a **Dominios** → Selecciona **programamega.com**
3. Click en **DNS / Nameservers**
4. Asegúrate de tener estos registros DNS:

   ```
   Tipo: A
   Nombre: @
   Valor: 2.25.217.236
   TTL: 14400

   Tipo: A
   Nombre: www
   Valor: 2.25.217.236
   TTL: 14400
   ```

5. Guarda los cambios (puede tardar 1-24 horas en propagarse)

---

## 🚀 PASO 2: Desplegar en el VPS

### 2.1 Conectarse al VPS

Via Hostinger Browser Terminal o desde PowerShell:
```bash
ssh root@2.25.217.236
```

### 2.2 Actualizar código desde GitHub

```bash
cd /opt/inventlook
git pull origin main
```

### 2.3 Compilar la aplicación

```bash
mvn clean package -DskipTests
```

### 2.4 Configurar servicio systemd

```bash
# Copiar archivo de servicio
cp /opt/inventlook/deployment/inventlook.service /etc/systemd/system/

# Recargar systemd
sudo systemctl daemon-reload

# Habilitar servicio (inicia automáticamente al reiniciar)
sudo systemctl enable inventlook

# Iniciar servicio
sudo systemctl start inventlook

# Verificar estado
sudo systemctl status inventlook
```

Comandos útiles del servicio:
```bash
sudo systemctl stop inventlook      # Detener
sudo systemctl restart inventlook   # Reiniciar
sudo systemctl status inventlook    # Ver estado
sudo journalctl -u inventlook -f    # Ver logs en tiempo real
```

---

## 🌐 PASO 3: Instalar y configurar Nginx + SSL

### 3.1 Instalar Nginx y Certbot

```bash
sudo apt update
sudo apt install nginx certbot python3-certbot-nginx -y
```

### 3.2 Configurar Nginx

```bash
# Copiar configuración
sudo cp /opt/inventlook/deployment/nginx-inventlook.conf /etc/nginx/sites-available/inventlook

# Crear enlace simbólico
sudo ln -s /etc/nginx/sites-available/inventlook /etc/nginx/sites-enabled/

# Eliminar configuración por defecto
sudo rm /etc/nginx/sites-enabled/default

# Probar configuración
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
```

### 3.3 Obtener certificado SSL (Let's Encrypt)

**IMPORTANTE:** Espera a que el DNS se haya propagado (verifica con `ping programamega.com`)

```bash
sudo certbot --nginx -d programamega.com -d www.programamega.com
```

Sigue las instrucciones:
- Ingresa tu email
- Acepta los términos
- Certbot configurará SSL automáticamente

Renovación automática (ya está configurada):
```bash
sudo systemctl status certbot.timer
```

---

## ✅ PASO 4: Verificar el despliegue

1. **Verificar servicio Java:**
   ```bash
   sudo systemctl status inventlook
   ```

2. **Verificar Nginx:**
   ```bash
   sudo systemctl status nginx
   ```

3. **Verificar puerto 8080 (interno):**
   ```bash
   netstat -tlnp | grep 8080
   ```

4. **Acceder a la aplicación:**
   - HTTP: http://programamega.com (redirige a HTTPS)
   - HTTPS: https://programamega.com ✅
   - HTTPS: https://www.programamega.com ✅

---

## 🔒 Seguridad

El despliegue incluye:
- ✅ Certificado SSL/TLS con Let's Encrypt (HTTPS)
- ✅ Redirección automática HTTP → HTTPS
- ✅ Aplicación Java escucha solo en localhost (127.0.0.1:8080)
- ✅ Nginx actúa como proxy reverso (única interfaz pública)
- ✅ Firewall configurado (solo puertos 80, 443, 22)

---

## 🔄 Actualizar la aplicación

Cuando hagas cambios en el código:

1. **Subir cambios a GitHub:**
   ```bash
   git add .
   git commit -m "Descripción del cambio"
   git push origin main
   ```

2. **En el VPS:**
   ```bash
   cd /opt/inventlook
   git pull origin main
   mvn clean package -DskipTests
   sudo systemctl restart inventlook
   ```

---

## 🐛 Troubleshooting

### Ver logs de la aplicación:
```bash
sudo journalctl -u inventlook -f
```

### Ver logs de Nginx:
```bash
sudo tail -f /var/log/nginx/inventlook-error.log
sudo tail -f /var/log/nginx/inventlook-access.log
```

### Verificar conexión MySQL:
```bash
mysql -u inventlook -pinventlook2024 -e "SHOW DATABASES;"
```

### Renovar certificado SSL manualmente:
```bash
sudo certbot renew --dry-run  # Prueba
sudo certbot renew            # Renovación real
```

---

## 📞 Comandos rápidos

```bash
# Reiniciar todo
sudo systemctl restart inventlook nginx

# Ver estado de servicios
sudo systemctl status inventlook nginx mysql

# Actualizar aplicación
cd /opt/inventlook && git pull && mvn clean package -DskipTests && sudo systemctl restart inventlook
```
