# 🚀 Guía Rápida de Inicio

## Pasos para empezar con InventLook

### 1️⃣ Prueba Local (5 minutos)

```bash
# Cambiar a perfil dev (no requiere MySQL)
# Edita src/main/resources/application.properties
spring.profiles.active=dev

# Ejecutar
./mvnw spring-boot:run

# Acceder a: http://localhost:8080
```

### 2️⃣ Configurar Variables de Entorno

```bash
# Windows
setup.bat

# Linux/Mac
chmod +x setup.sh
./setup.sh
```

### 3️⃣ Subir a GitHub

```bash
# Crear repositorio en https://github.com/new
# Luego:

git init
git add .
git commit -m "Initial commit: InventLook inventory system"
git remote add origin https://github.com/TU-USUARIO/inventlook.git
git branch -M main
git push -u origin main
```

### 4️⃣ Desplegar en VPS

Ver guía completa en: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

## 📚 Documentación Completa

- **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Cómo probar todas las funcionalidades
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Despliegue paso a paso en VPS
- **[SECURITY_RECOMMENDATIONS.md](SECURITY_RECOMMENDATIONS.md)** - Mejoras de seguridad

---

## 🆘 Soporte Rápido

**Puerto 8080 ocupado:**
```bash
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

**Ver logs:**
```bash
# En el VPS
sudo journalctl -u inventlook -f
```

**Reiniciar aplicación:**
```bash
sudo systemctl restart inventlook
```

---

## 🔗 Recursos

- Documentación Spring Boot: https://spring.io/projects/spring-boot
- MySQL: https://dev.mysql.com/doc/
- Let's Encrypt: https://letsencrypt.org/

---

**Desarrollado para gestión de inventario empresarial** 🏢
