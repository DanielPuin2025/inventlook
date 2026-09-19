# 🔒 RECOMENDACIONES DE SEGURIDAD

## ⚠️ Problemas de Seguridad Detectados

### 1. Contraseñas en Texto Plano

**Problema:** Las contraseñas se almacenan sin hashear en la base de datos.

**Solución:** Implementar BCrypt para hashear contraseñas.

**Pasos para corregir:**

1. Agregar dependencia Spring Security en `pom.xml`:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

2. Crear clase de configuración de seguridad:
```java
// src/main/java/com/inventlook/SecurityConfig.java
package com.inventlook;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()
            )
            .csrf(csrf -> csrf.disable());
        return http.build();
    }
}
```

3. Modificar `UsuarioService.java`:
```java
// Inyectar PasswordEncoder
private final PasswordEncoder passwordEncoder;

public UsuarioService(UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder) {
    this.usuarioRepository = usuarioRepository;
    this.passwordEncoder = passwordEncoder;
}

// En registrarUsuario, hashear la contraseña:
nuevoUsuario.setContrasena(passwordEncoder.encode(contrasena));

// En validarInicioSesion, comparar con BCrypt:
return passwordEncoder.matches(contrasena, usuarioReal.getContrasena());
```

---

### 2. Protección CSRF

**Problema:** CSRF está deshabilitado en producción.

**Solución:** Habilitar CSRF y usar tokens en formularios Thymeleaf.

En tus formularios HTML, agrega:
```html
<form method="POST" th:action="@{/login}">
    <input type="hidden" th:name="${_csrf.parameterName}" th:value="${_csrf.token}"/>
    <!-- resto del formulario -->
</form>
```

---

### 3. Validación de Entrada

**Problema:** No hay validación de datos en los controladores.

**Solución:** Agregar Bean Validation.

1. Agregar anotaciones en las entidades:
```java
@Column(nullable = false, length = 100)
@NotBlank(message = "El nombre es obligatorio")
@Size(min = 3, max = 100, message = "El nombre debe tener entre 3 y 100 caracteres")
private String nombre;

@Column(nullable = false, unique = true)
@NotBlank(message = "El correo es obligatorio")
@Email(message = "Formato de correo inválido")
private String correo;
```

2. En los controladores, usar `@Valid`:
```java
@PostMapping("/registro")
public String registrar(@Valid Usuario usuario, BindingResult result) {
    if (result.hasErrors()) {
        return "registro";
    }
    // resto del código
}
```

---

### 4. SQL Injection

**Estado:** ✅ Protegido por JPA/Hibernate (usa consultas parametrizadas).

Tu código ya está protegido contra SQL injection porque usas Spring Data JPA.

---

### 5. XSS (Cross-Site Scripting)

**Estado:** ✅ Protegido por Thymeleaf.

Thymeleaf escapa automáticamente HTML. Mantén el uso de `th:text` en lugar de `th:utext`.

---

### 6. Sesiones HTTP

**Problema:** No hay gestión de sesiones de usuario.

**Solución:** Implementar sesiones con Spring Security o HttpSession.

Opción simple con HttpSession:
```java
@PostMapping("/login")
public String login(@RequestParam String telefono, 
                   @RequestParam String contrasena,
                   HttpSession session) {
    if (usuarioService.validarInicioSesion(telefono, contrasena)) {
        Usuario usuario = usuarioService.buscarPorTelefono(telefono);
        session.setAttribute("usuario", usuario);
        return "redirect:/dashboard";
    }
    return "redirect:/login?error=true";
}
```

Y en los controladores protegidos:
```java
@GetMapping("/dashboard")
public String dashboard(HttpSession session, Model model) {
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        return "redirect:/login";
    }
    // resto del código
}
```

---

### 7. Rate Limiting

**Problema:** No hay protección contra ataques de fuerza bruta.

**Solución:** Implementar Bucket4j o limitar intentos de login.

Código simple para limitar intentos:
```java
// Agregar en UsuarioService
private Map<String, Integer> intentosFallidos = new HashMap<>();
private Map<String, LocalDateTime> bloqueos = new HashMap<>();

public boolean validarInicioSesion(String telefono, String contrasena) {
    // Verificar si está bloqueado
    if (bloqueos.containsKey(telefono)) {
        LocalDateTime desbloqueaEn = bloqueos.get(telefono);
        if (LocalDateTime.now().isBefore(desbloqueaEn)) {
            throw new RuntimeException("Cuenta bloqueada temporalmente. Intenta en 15 minutos.");
        } else {
            bloqueos.remove(telefono);
            intentosFallidos.remove(telefono);
        }
    }
    
    Optional<Usuario> usuarioBuscado = usuarioRepository.findByTelefono(telefono);
    if (usuarioBuscado.isEmpty()) {
        return false;
    }
    
    Usuario usuarioReal = usuarioBuscado.get();
    boolean esValido = passwordEncoder.matches(contrasena, usuarioReal.getContrasena());
    
    if (!esValido) {
        // Incrementar intentos fallidos
        intentosFallidos.put(telefono, intentosFallidos.getOrDefault(telefono, 0) + 1);
        
        // Bloquear después de 5 intentos
        if (intentosFallidos.get(telefono) >= 5) {
            bloqueos.put(telefono, LocalDateTime.now().plusMinutes(15));
            intentosFallidos.remove(telefono);
            throw new RuntimeException("Demasiados intentos fallidos. Cuenta bloqueada por 15 minutos.");
        }
        return false;
    }
    
    // Login exitoso, limpiar intentos
    intentosFallidos.remove(telefono);
    return true;
}
```

---

### 8. Logs de Auditoría

**Recomendación:** Registrar acciones importantes.

```java
@Service
public class AuditoriaService {
    private static final Logger logger = LoggerFactory.getLogger(AuditoriaService.class);
    
    public void registrarAcceso(String usuario, String accion) {
        logger.info("Usuario: {} - Acción: {} - Fecha: {}", 
                    usuario, accion, LocalDateTime.now());
    }
}
```

---

### 9. HTTPS en Producción

**CRÍTICO:** Usa HTTPS en producción (el guide ya incluye Let's Encrypt).

Nunca transmitas contraseñas por HTTP sin cifrar.

---

### 10. Variables de Entorno

**Estado:** ✅ Ya corregido en este proyecto.

Las credenciales ahora se leen de variables de entorno.

---

## 🎯 Prioridades de Implementación

### Alta Prioridad (Antes de producción):
1. ✅ Variables de entorno (ya hecho)
2. ⚠️ Hasheo de contraseñas con BCrypt
3. ⚠️ Gestión de sesiones HTTP
4. ✅ HTTPS con Let's Encrypt (en el deployment guide)

### Media Prioridad:
5. Rate limiting en login
6. Validación de entrada con Bean Validation
7. Logs de auditoría

### Baja Prioridad (mejoras futuras):
8. CSRF habilitado
9. Autenticación de dos factores (2FA)
10. Política de contraseñas fuertes

---

## 📝 Checklist de Seguridad para Producción

- [ ] Contraseñas hasheadas con BCrypt
- [ ] Variables de entorno configuradas en VPS
- [ ] HTTPS configurado (Let's Encrypt)
- [ ] Firewall configurado (solo puertos 80, 443, 22)
- [ ] MySQL solo acepta conexiones locales
- [ ] Backups automáticos de base de datos
- [ ] Logs de aplicación monitoreados
- [ ] Actualizar dependencias regularmente
- [ ] Rate limiting en endpoints críticos
- [ ] Sesiones HTTP con timeout

---

## 🔐 Comandos Útiles de Seguridad

### Verificar puertos abiertos (VPS)
```bash
sudo ss -tulpn
```

### Configurar firewall básico
```bash
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
```

### Backup de base de datos
```bash
mysqldump -u inventlook -p inventlook > backup_$(date +%Y%m%d).sql
```

### Ver intentos de acceso SSH
```bash
sudo tail -f /var/log/auth.log | grep sshd
```

---

## 📚 Recursos Adicionales

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Spring Security Reference](https://docs.spring.io/spring-security/reference/index.html)
- [BCrypt en Spring Boot](https://www.baeldung.com/spring-security-registration-password-encoding-bcrypt)
