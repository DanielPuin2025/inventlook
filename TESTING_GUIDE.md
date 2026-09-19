# 🧪 Guía de Pruebas - InventLook

## 📝 Resumen de Funcionalidades

Tu sistema InventLook tiene las siguientes funcionalidades:

1. **Sistema de Usuarios**
   - Registro de nuevos usuarios
   - Login con teléfono + contraseña
   - Recuperación de contraseña por correo
   - Gestión de cuentas (activar/desactivar)
   - Roles: ADMINISTRADOR y EMPLEADO

2. **Gestión de Productos**
   - Crear productos con código único
   - Asignar categorías
   - Control de stock (Tienda + Bodega)
   - Estados automáticos: Óptimo, Stock bajo, Agotado
   - Registro de proveedor

3. **Gestión de Categorías**
   - Crear, editar y eliminar categorías
   - Nombres únicos

4. **Movimientos de Inventario**
   - Registro de entradas y salidas
   - Tipos: Compra, Venta, Traslado, Ajuste
   - Historial completo

5. **Dashboard**
   - Estadísticas de productos
   - Alertas de stock bajo
   - Resumen de categorías

---

## 🚀 PRUEBAS LOCALES PASO A PASO

### Opción 1: Prueba Rápida con H2 (sin instalar MySQL)

```bash
# 1. Asegúrate que esté activo el perfil dev
# Verifica en src/main/resources/application.properties:
spring.profiles.active=dev

# 2. Ejecutar la aplicación
./mvnw spring-boot:run

# 3. Espera a ver este mensaje:
# "Tomcat started on port(s): 8080"

# 4. Abre tu navegador en:
http://localhost:8080
```

**Ventajas de H2:**
- ✅ No necesitas instalar MySQL
- ✅ Base de datos en memoria (se resetea al reiniciar)
- ✅ Ideal para pruebas rápidas
- ✅ Consola visual en: http://localhost:8080/h2-console

**Configuración consola H2:**
```
JDBC URL: jdbc:h2:mem:inventlook
User Name: sa
Password: (dejar vacío)
```

---

### Opción 2: Prueba con MySQL Local

```bash
# 1. Instalar MySQL 8.0
# Windows: https://dev.mysql.com/downloads/installer/
# Configura password: root123 (o el que prefieras)

# 2. Crear la base de datos
mysql -u root -p
# Ingresa tu password

CREATE DATABASE inventlook CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'inventlook'@'localhost' IDENTIFIED BY 'inventlook2024';
GRANT ALL PRIVILEGES ON inventlook.* TO 'inventlook'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 3. Importar datos de ejemplo
mysql -u inventlook -pinventlook2024 inventlook < inventlook.sql

# 4. Cambiar a perfil prod
# Edita src/main/resources/application.properties:
spring.profiles.active=prod

# 5. Ejecutar
./mvnw spring-boot:run
```

---

## ✅ CASOS DE PRUEBA

### 1. Registro de Usuario

1. Ve a: http://localhost:8080/registro
2. Completa el formulario:
   ```
   Nombre: Juan Pérez
   Correo: juan@example.com
   Contraseña: 12345678
   Teléfono: 3001234567
   ```
3. Click "Registrarse"
4. **Resultado esperado**: Redirección a login con mensaje de éxito

**Pruebas adicionales:**
- ❌ Correo duplicado → debe mostrar error
- ❌ Teléfono duplicado → debe mostrar error
- ❌ Campos vacíos → debe mostrar error

---

### 2. Inicio de Sesión

1. Ve a: http://localhost:8080/login
2. Ingresa:
   ```
   Teléfono: 3001234567
   Contraseña: 12345678
   ```
3. Click "Iniciar Sesión"
4. **Resultado esperado**: Redirección al dashboard

**Pruebas adicionales:**
- ❌ Teléfono inexistente → error
- ❌ Contraseña incorrecta → error
- ❌ Usuario inactivo → no puede ingresar

---

### 3. Recuperación de Contraseña

**⚠️ Requiere configuración de correo Gmail**

1. Ve a: http://localhost:8080/recuperar-contrasena
2. Ingresa correo registrado: juan@example.com
3. Click "Enviar código"
4. Revisa tu correo (revisa spam también)
5. Ingresa el código de 6 dígitos
6. Crea nueva contraseña
7. **Resultado esperado**: Contraseña actualizada, login exitoso

**Nota:** Si no tienes correo configurado, este feature no funcionará.

---

### 4. Crear Categoría

1. Login como usuario
2. Ve a: http://localhost:8080/categorias
3. Click "Agregar Categoría"
4. Ingresa nombre: "Lácteos"
5. Click "Guardar"
6. **Resultado esperado**: Categoría aparece en la lista ordenada alfabéticamente

**Pruebas adicionales:**
- ❌ Nombre duplicado → error
- ✏️ Editar categoría → actualiza correctamente
- 🗑️ Eliminar categoría → se elimina (solo si no tiene productos)

---

### 5. Crear Producto

1. Ve a: http://localhost:8080/productos
2. Click "Agregar Producto"
3. Completa:
   ```
   Código: LEH001
   Nombre: Leche Entera
   Categoría: Lácteos
   Stock Tienda: 15
   Stock Bodega: 30
   Proveedor: Alpina
   ```
4. Click "Guardar"
5. **Resultado esperado**: 
   - Producto creado
   - Estado: "Óptimo" (total > 20)
   - Aparece en listado

**Pruebas de estados automáticos:**
- Stock Tienda: 5, Bodega: 10 → Estado: "Stock bajo" (total < 20)
- Stock Tienda: 0, Bodega: 0 → Estado: "Agotado"
- Stock Tienda: 20, Bodega: 5 → Estado: "Óptimo" (total ≥ 20)

**Pruebas adicionales:**
- ❌ Código duplicado → error
- ✏️ Editar producto → actualiza y recalcula estado
- 🗑️ Eliminar producto → se elimina correctamente

---

### 6. Registrar Movimiento

1. Ve a: http://localhost:8080/movimientos
2. Click "Registrar Movimiento"
3. Completa:
   ```
   Producto: Leche Entera
   Tipo: ENTRADA
   Origen: Bodega
   Destino: Tienda
   Cantidad: 10
   Observaciones: Reposición matutina
   ```
4. Click "Guardar"
5. **Resultado esperado**:
   - Stock Bodega: 30 - 10 = 20
   - Stock Tienda: 15 + 10 = 25
   - Movimiento registrado en historial

**Tipos de movimientos a probar:**
- ✅ ENTRADA (Compra a proveedor)
- ✅ SALIDA (Venta a cliente)
- ✅ TRASLADO (Bodega ↔ Tienda)
- ✅ AJUSTE (Corrección de inventario)

---

### 7. Dashboard y Alertas

1. Ve a: http://localhost:8080/dashboard
2. **Verifica**:
   - Total de productos
   - Productos con stock bajo
   - Productos agotados
   - Distribución por categorías

3. Ve a: http://localhost:8080/alertas
4. **Verifica**:
   - Lista de productos con stock bajo o agotados
   - Indicadores visuales por estado

---

### 8. Gestión de Cuentas (Solo Admin)

1. Login como administrador
2. Ve a: http://localhost:8080/cuentas
3. **Verifica lista de usuarios**:
   - Nombre, correo, teléfono, rol, estado
4. **Acciones:**
   - 🔄 Cambiar rol (EMPLEADO ↔ ADMINISTRADOR)
   - 🔒 Desactivar cuenta
   - ✅ Activar cuenta
   - 🗑️ Eliminar usuario

---

## 🔍 VERIFICACIÓN DE DATOS

### Consola H2 (si usas perfil dev)

```
URL: http://localhost:8080/h2-console
JDBC URL: jdbc:h2:mem:inventlook
Usuario: sa
Password: (vacío)
```

**Consultas útiles:**
```sql
-- Ver todos los usuarios
SELECT * FROM usuario;

-- Ver productos con stock
SELECT nombre, actual, bodega, estado FROM producto;

-- Ver últimos movimientos
SELECT * FROM movimiento ORDER BY fecha DESC LIMIT 10;

-- Productos con stock bajo
SELECT nombre, (actual + bodega) as total 
FROM producto 
WHERE (actual + bodega) < 20 AND (actual + bodega) > 0;
```

---

### MySQL (si usas perfil prod)

```bash
mysql -u inventlook -p inventlook

# Mismas consultas SQL de arriba
```

---

## 🐛 PROBLEMAS COMUNES

### Error: Puerto 8080 ya en uso
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8080
kill -9 <PID>
```

### Error: No se puede conectar a MySQL
```bash
# Verifica que MySQL esté corriendo
# Windows: Services → MySQL80 → Start
# Linux: sudo systemctl status mysql

# Verifica credenciales en application-prod.properties
```

### Error: Contraseña de Gmail no funciona
```
1. Ve a https://myaccount.google.com/security
2. Habilita "Verificación en 2 pasos"
3. Ve a "Contraseñas de aplicaciones"
4. Genera una nueva para "Mail"
5. Usa ESA contraseña (no tu contraseña normal)
```

### Error: Las tablas no se crean
```
# Verifica que el perfil correcto esté activo
# Si usas H2: spring.profiles.active=dev
# Si usas MySQL: spring.profiles.active=prod

# Con MySQL, verifica que importaste el SQL:
mysql -u inventlook -p inventlook < inventlook.sql
```

---

## 📊 CHECKLIST DE PRUEBAS COMPLETO

- [ ] Registro de usuario nuevo
- [ ] Login exitoso
- [ ] Login con credenciales incorrectas (debe fallar)
- [ ] Recuperación de contraseña (si tienes correo configurado)
- [ ] Crear categoría
- [ ] Editar categoría
- [ ] Eliminar categoría vacía
- [ ] Crear producto con estado Óptimo
- [ ] Crear producto con estado Stock Bajo
- [ ] Crear producto con estado Agotado
- [ ] Editar producto y verificar actualización de estado
- [ ] Código de producto duplicado (debe fallar)
- [ ] Movimiento ENTRADA (Compra)
- [ ] Movimiento SALIDA (Venta)
- [ ] Movimiento TRASLADO (Bodega → Tienda)
- [ ] Movimiento TRASLADO (Tienda → Bodega)
- [ ] Verificar actualización automática de stock
- [ ] Dashboard muestra estadísticas correctas
- [ ] Alertas muestra productos críticos
- [ ] Cambiar rol de usuario (Admin)
- [ ] Desactivar cuenta de usuario (Admin)
- [ ] Activar cuenta de usuario (Admin)
- [ ] Eliminar usuario (Admin)

---

## 🎯 SIGUIENTE PASO

Una vez que hayas probado localmente y todo funcione:

1. **Proteger credenciales** (ver DEPLOYMENT_GUIDE.md - Parte 2)
2. **Subir a GitHub** (ver DEPLOYMENT_GUIDE.md - Parte 2)
3. **Desplegar en VPS** (ver DEPLOYMENT_GUIDE.md - Parte 3)
4. **Configurar dominio** (ver DEPLOYMENT_GUIDE.md - Parte 4)

¡Éxito con tus pruebas! 🚀
