package com.inventlook;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;

@Controller
public class UsuarioController {
    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    // Abre la ventana de INICIAR SESION
    @GetMapping("/login")
    public String mostrarLogin() {
        return "login";
    }

    @GetMapping("/logout")
    public String cerrarSesion(HttpSession sesion) {
        sesion.invalidate();
        return "redirect:/login";
    }

    // ✅ INICIO DE SESION CON NUMERO DE TELEFONO + CONTRASENA
    @PostMapping("/iniciar-sesion")
    public String iniciarSesion(
        @RequestParam String telefono, // ✅ AHORA RECIBE TELEFONO EN LUGAR DE "USUARIO"
        @RequestParam String contrasena,
        Model model,
        HttpSession sesion) {

        // 1. Validar con telefono
        boolean accesoValido = usuarioService.validarInicioSesion(telefono, contrasena);

        if (accesoValido) {
            // 2. Buscar los datos del usuario por TELEFONO
            Usuario usuarioLogueado = usuarioService.buscarPorTelefono(telefono);

            // 3. Guardar datos en la sesion
            sesion.setAttribute("idUsuario", usuarioLogueado.getIdUsuario());
            sesion.setAttribute("nombreUsuario", usuarioLogueado.getNombre()); // ✅ Se guarda el NOMBRE real para mostrar en pantalla
            sesion.setAttribute("rolUsuario", usuarioLogueado.getRol());
            sesion.setAttribute("telefonoUsuario", telefono); // Opcional: guardar tambien el telefono

            // 4. Ir al panel principal
            return "redirect:/dashboard";
        } else {
            model.addAttribute("mensaje", "Error: Numero de telefono o contraseña incorrectos");
            return "login";
        }
    }

    // =============================================
    // GESTION DE CUENTAS (SOLO ADMINISTRADOR)
    // =============================================

    // Ver lista de cuentas
    @GetMapping("/cuentas")
    public String gestionarCuentas(HttpSession sesion, Model modelo, RedirectAttributes ra) {
        String rol = (String) sesion.getAttribute("rolUsuario");
        if (rol == null || !rol.equals("ADMINISTRADOR")) {
            ra.addFlashAttribute("error", "Acceso exclusivo para Administradores");
            return "redirect:/dashboard";
        }
        modelo.addAttribute("listaUsuarios", usuarioService.listarTodos());
        return "cuentas";
    }

    // Eliminar una cuenta
    @GetMapping("/cuentas/eliminar/{id}")
    public String eliminarCuenta(@PathVariable Integer id,
                                  HttpSession sesion,
                                  RedirectAttributes ra) {
        String rol = (String) sesion.getAttribute("rolUsuario");
        if (rol == null || !rol.equals("ADMINISTRADOR")) {
            ra.addFlashAttribute("error", "Acceso exclusivo para Administradores");
            return "redirect:/dashboard";
        }

        Integer miId = (Integer) sesion.getAttribute("idUsuario");
        if (id.equals(miId)) {
            ra.addFlashAttribute("error", "No puedes borrar tu propia cuenta");
            return "redirect:/cuentas";
        }

        usuarioService.eliminarUsuario(id);
        ra.addFlashAttribute("exito", "Cuenta eliminada correctamente — ya no tiene acceso al sistema");
        return "redirect:/cuentas";
    }
}