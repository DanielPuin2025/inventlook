# 🎯 PRÓXIMOS PASOS - InventLook

## ✅ Completado

- [x] Revisión completa del código
- [x] Corrección de seguridad (variables de entorno)
- [x] Documentación profesional creada
- [x] Scripts de despliegue preparados
- [x] Commit inicial en Git

---

## 📋 FASE 1: PRUEBAS LOCALES (Hoy - 30-60 min)

### 1. Probar con H2 (más rápido)

```bash
# El perfil dev ya está activo por defecto
./mvnw spring-boot:run
```

Accede a: http://localhost:8080

**Checklist de pruebas:**
- [ ] Registrar nuevo usuario
- [ ] Iniciar sesión
- [ ] Crear categoría
- [ ] Crear producto
- [ ] Registrar movimiento
- [ ] Ver dashboard
- [ ] Ver alertas
- [ ] Cerrar sesión

Ver guía completa en: [TESTING_GUIDE.md](TESTING_GUIDE.md)

---

## 📦 FASE 2: SUBIR A GITHUB (Hoy - 10 min)

### 1. Crear repositorio en GitHub

1. Ve a: https://github.com/new
2. Nombre: `inventlook`
3. Descripción: "Sistema de gestión de inventario con Spring Boot y MySQL"
4. Visibilidad: **Private** (recomendado para código con lógica de negocio)
5. NO inicialices con README (ya tienes uno)
6. Click "Create repository"

### 2. Conectar y subir

```bash
cd "C:\Users\Daniel_Puin\Desktop\REVISION PROYECTOS\inventlook (1)"

# Ya hiciste el commit, ahora conecta con GitHub:
git remote add origin https://github.com/TU-USUARIO/inventlook.git
git branch -M main
git push -u origin main
```

**Reemplaza `TU-USUARIO` con tu usuario de GitHub**

### 3. Verificar

Ve a tu repositorio en GitHub y verifica que todo se haya subido correctamente.

---

## 🖥️ FASE 3: DESPLEGAR EN VPS HOSTINGER (1-2 horas)

### Requisitos previos

1. **Acceso SSH al VPS:**
   - IP del servidor
   - Usuario y contraseña (o llave SSH)
   
2. **Datos de tu VPS:**
   - Sistema operativo (Ubuntu 20.04+, CentOS 8+)
   - Memoria RAM (mínimo 2GB)

### Pasos detallados

**Todo está documentado en:** [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

**Resumen:**
1. Conectar por SSH
2. Instalar Java 17, MySQL 8.0, Nginx
3. Configurar MySQL (crear base de datos y usuario)
4. Clonar repositorio desde GitHub
5. Crear archivo `.env` con credenciales
6. Compilar aplicación
7. Configurar servicio systemd
8. Configurar Nginx
9. Iniciar servicios

**Comando inicial:**
```bash
ssh root@TU_IP_VPS
```

---

## 🌐 FASE 4: CONFIGURAR DOMINIO (15-30 min)

### En Hostinger Panel

1. Accede a tu panel de Hostinger
2. Selecciona `programamega.com`
3. Ve a **DNS Zone** o **DNS Settings**
4. Modifica/agrega estos registros:

```
Tipo    Nombre    Contenido           TTL
A       @         TU_IP_VPS          3600
A       www       TU_IP_VPS          3600
```

5. Guarda los cambios
6. Espera 5-30 minutos (propagación DNS)

### Verificar propagación

```bash
# Desde tu computadora local
ping programamega.com
nslookup programamega.com
```

### Instalar SSL (Let's Encrypt)

```bash
# En el VPS (después de que el dominio apunte correctamente)
sudo certbot --nginx -d programamega.com -d www.programamega.com
```

Sigue las instrucciones:
- Email: tu correo
- Acepta términos: Y
- Redirect HTTP a HTTPS: 2 (Sí)

### Verificar

Accede a: https://programamega.com

---

## 🔐 ANTES DE PRODUCCIÓN

### Seguridad crítica

- [ ] Cambiar contraseñas de MySQL de ejemplo
- [ ] Configurar contraseña de aplicación de Gmail
- [ ] Verificar que `.env` NO esté en GitHub
- [ ] HTTPS activo con certificado válido
- [ ] Firewall configurado (solo puertos 22, 80, 443)

### Configuración

- [ ] Variables de entorno configuradas en VPS
- [ ] Base de datos importada correctamente
- [ ] Servicio systemd funcionando
- [ ] Nginx como proxy reverso
- [ ] Logs accesibles

---

## 📞 COMANDOS ÚTILES

### Local (desarrollo)

```bash
# Ejecutar aplicación
./mvnw spring-boot:run

# Compilar
./mvnw clean package

# Limpiar y recompilar
./mvnw clean install
```

### VPS (producción)

```bash
# Ver estado del servicio
sudo systemctl status inventlook

# Ver logs en tiempo real
sudo journalctl -u inventlook -f

# Ver últimos 100 logs
sudo journalctl -u inventlook -n 100

# Reiniciar aplicación
sudo systemctl restart inventlook

# Reiniciar Nginx
sudo systemctl restart nginx

# Ver puertos en uso
sudo ss -tulpn | grep LISTEN
```

### Git

```bash
# Ver estado
git status

# Ver commits
git log --oneline

# Actualizar en VPS
cd /opt/inventlook
git pull origin main
./deployment/deploy.sh
```

---

## 🐛 TROUBLESHOOTING

### Puerto 8080 ocupado

```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux
sudo lsof -i :8080
sudo kill -9 <PID>
```

### Error de conexión MySQL

```bash
# Verificar que MySQL esté corriendo
sudo systemctl status mysql

# Ver logs de MySQL
sudo tail -f /var/log/mysql/error.log

# Conectar manualmente
mysql -u inventlook -p
```

### Aplicación no inicia en VPS

```bash
# Ver logs detallados
sudo journalctl -u inventlook -n 200 --no-pager

# Verificar que el JAR existe
ls -lh /opt/inventlook/target/*.jar

# Probar ejecución manual
cd /opt/inventlook
export $(cat .env | xargs)
java -jar target/inventlook-0.0.1-SNAPSHOT.jar
```

### Dominio no resuelve

```bash
# Verificar DNS
nslookup programamega.com

# Si no resuelve, espera más tiempo (hasta 24h en casos extremos)
# O verifica que los registros A en Hostinger sean correctos
```

---

## 📚 DOCUMENTACIÓN COMPLETA

1. **[QUICKSTART.md](QUICKSTART.md)** - Inicio rápido en 5 minutos
2. **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - 21 casos de prueba detallados
3. **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Despliegue paso a paso en VPS
4. **[SECURITY_RECOMMENDATIONS.md](SECURITY_RECOMMENDATIONS.md)** - Mejoras de seguridad
5. **[REVISION_SUMMARY.md](REVISION_SUMMARY.md)** - Resumen ejecutivo

---

## 🎯 CHECKLIST COMPLETO

### Desarrollo Local
- [ ] Código revisado y entendido
- [ ] Pruebas locales completadas
- [ ] Todas las funcionalidades verificadas

### GitHub
- [ ] Repositorio creado en GitHub
- [ ] Código subido correctamente
- [ ] README visible y claro

### VPS Hostinger
- [ ] SSH accesible
- [ ] Dependencias instaladas (Java, MySQL, Nginx)
- [ ] Base de datos configurada
- [ ] Aplicación compilada
- [ ] Servicio systemd funcionando
- [ ] Aplicación accesible en puerto 8080

### Dominio
- [ ] Registros A configurados en Hostinger
- [ ] DNS propagado correctamente
- [ ] Nginx como proxy reverso
- [ ] SSL instalado con Let's Encrypt
- [ ] https://programamega.com funcional

### Seguridad
- [ ] Variables de entorno configuradas
- [ ] Contraseñas cambiadas de valores por defecto
- [ ] Firewall configurado
- [ ] HTTPS activo
- [ ] Backups configurados

---

## 🏆 RESULTADO FINAL

Cuando completes todas las fases:

✅ Aplicación funcionando localmente  
✅ Código versionado en GitHub (privado)  
✅ Aplicación desplegada en VPS 24/7  
✅ Accesible en https://programamega.com  
✅ SSL válido (candado verde)  
✅ Completamente funcional y seguro  

---

## 💡 TIPS FINALES

1. **Haz las pruebas locales primero** - No despliegues a producción sin probar localmente
2. **Guarda las credenciales de forma segura** - Anota las contraseñas de MySQL, correo, etc.
3. **Haz backups regulares** - Usa `deployment/backup-db.sh`
4. **Monitorea los logs** - Revisa periódicamente con `journalctl`
5. **Actualiza regularmente** - Mantén Java y MySQL actualizados

---

¿Necesitas ayuda con algún paso específico? Consulta la documentación correspondiente o revisa la sección de troubleshooting. ¡Éxito con tu despliegue! 🚀
