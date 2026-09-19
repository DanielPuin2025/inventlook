package com.inventlook;

import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {
    private final UsuarioRepository usuarioRepository;

    public UsuarioService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    // ✅ Registrar nuevo usuario
    public Usuario registrarUsuario(String nombre, String correo, String contrasena, String telefono) {
        // 1. Verificar si el correo ya existe
        if (usuarioRepository.existsByCorreo(correo)) {
            throw new RuntimeException("El correo ya esta registrado en el sistema");
        }
        // ✅ NUEVO: Verificar si el telefono ya existe
        if (usuarioRepository.existsByTelefono(telefono)) {
            throw new RuntimeException("El numero de telefono ya esta registrado en el sistema");
        }
        // 2. Creamos el usuario
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setContrasena(contrasena);
        nuevoUsuario.setTelefono(telefono);
        nuevoUsuario.setFechaRegistro(LocalDateTime.now());
        // 3. Guardamos
        return usuarioRepository.save(nuevoUsuario);
    }

    // ✅ Listar todos — ORDENADOS ALFABETICAMENTE (A-Z)
    public List<Usuario> listarTodos() {
        return usuarioRepository.findAllByOrderByNombreAsc();
    }

    // ✅ Buscar por correo
    public Optional<Usuario> buscarPorCorreo(String correo) {
        return usuarioRepository.findByCorreo(correo);
    }

    // ✅ VALIDAR INICIO DE SESION: TELEFONO + CONTRASEÑA
    public boolean validarInicioSesion(String telefono, String contrasena) {
        // 1. Busca por TELEFONO en lugar de nombre
        Optional<Usuario> usuarioBuscado = usuarioRepository.findByTelefono(telefono);
        // 2. Si NO existe
        if (usuarioBuscado.isEmpty()) {
            return false;
        }
        // 3. Compara contraseña
        Usuario usuarioReal = usuarioBuscado.get();
        return usuarioReal.getContrasena().equals(contrasena);
    }

    // ✅ Buscar usuario por telefono
    public Usuario buscarPorTelefono(String telefono) {
        return usuarioRepository.findByTelefono(telefono).orElse(null);
    }

    // ✅ Buscar por nombre (se mantiene para consultas internas)
    public Usuario buscarPorNombre(String nombre) {
        return usuarioRepository.findByNombre(nombre).orElse(null);
    }

    // ✅ Eliminar usuario por ID
    public void eliminarUsuario(Integer idUsuario) {
        usuarioRepository.deleteById(idUsuario);
    }

    // ✅ Buscar usuario por ID
    public Usuario buscarPorId(Integer idUsuario) {
        return usuarioRepository.findById(idUsuario).orElse(null);
    }
}