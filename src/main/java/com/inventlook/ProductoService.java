package com.inventlook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ProductoService {
    private final ProductoRepository productoRepository;
    private final MovimientoService movimientoService;

    public ProductoService(ProductoRepository productoRepository, MovimientoService movimientoService) {
        this.productoRepository = productoRepository;
        this.movimientoService = movimientoService;
    }

    // OBTENER TODOS LOS PRODUCTOS (lista general)
    public List<Producto> listarTodos() {
        return productoRepository.findAll();
    }

    // GUARDAR O ACTUALIZAR + CODIGO AUTOMATICO + REGLA DE ESTADO
    public Producto guardar(Producto producto) {
        // CODIGO AUTOMATICO: SOLO si es producto NUEVO (sin ID todavia)
        if (producto.getIdProducto() == null || producto.getIdProducto() == 0) {
            Long ultimoNumero = productoRepository.obtenerUltimoCodigoNumerico();
            int siguiente = (ultimoNumero == null) ? 1 : (ultimoNumero.intValue() + 1);
            // Formato: 001, 002, 003... (3 digitos con ceros adelante)
            String codigoGenerado = String.format("%03d", siguiente);
            producto.setCodigo(codigoGenerado);
        }

        // REGLA DE ESTADO: segun la suma de Actual + Bodega
        int total = 0;
        if (producto.getActual() != null) total += producto.getActual();
        if (producto.getBodega() != null) total += producto.getBodega();

        if (total <= 0) {
            producto.setEstado("Agotado");
        } else if (total < 20) {
            producto.setEstado("Stock bajo");
        } else {
            producto.setEstado("Optimo");
        }

        return productoRepository.save(producto);
    }

    // LOGICA PRINCIPAL: TRASLADO AUTOMATICO DESDE BODEGA
    @Transactional
    public void verificarYTrasladarDesdeBodega(Producto producto, Usuario usuario) {
        // Si Actual llego a 0 y Bodega tiene productos
        if (producto.getActual() == 0 && producto.getBodega() > 0) {
            int cantidadATrasladar = producto.getBodega();

            // Hacemos el traslado
            producto.setActual(cantidadATrasladar);
            producto.setBodega(0);
            productoRepository.save(producto);

            // Registramos el movimiento de TRASLADO
            Movimiento traslado = new Movimiento();
            traslado.setTipoMovimiento("TRASLADO");
            traslado.setCantidad(cantidadATrasladar);
            traslado.setFechaHora(LocalDateTime.now());
            traslado.setObservacion("Traslado automatico desde bodega a tienda");
            traslado.setProducto(producto);
            traslado.setNombreProducto(producto.getNombre());
            traslado.setUsuario(usuario);
            movimientoService.guardar(traslado);
        }
    }

    // VERIFICAR SI UN PRODUCTO ESTA SIN EXISTENCIAS
    public boolean estaSinExistencias(Producto producto) {
        return producto.getActual() == 0 && producto.getBodega() == 0;
    }

    // REGISTRAR SALIDA DE PRODUCTO (usa la logica automatica)
    @Transactional
    public String registrarSalida(Long idProducto, int cantidad, Usuario usuario) {
        Optional<Producto> productoOpt = productoRepository.findById(idProducto);
        if (productoOpt.isEmpty()) {
            return "Producto no encontrado";
        }

        Producto producto = productoOpt.get();
        int disponibleActual = producto.getActual() != null ? producto.getActual() : 0;
        int disponibleBodega = producto.getBodega() != null ? producto.getBodega() : 0;
        int totalDisponible = disponibleActual + disponibleBodega;

        if (totalDisponible < cantidad) {
            return "Error: No hay suficiente inventario disponible";
        }

        String observacion = "Salida normal de inventario";

        // Caso 1: Hay suficiente en Actual
        if (disponibleActual >= cantidad) {
            producto.setActual(disponibleActual - cantidad);
        }
        // Caso 2: No alcanza Actual, usamos tambien Bodega
        else {
            int faltante = cantidad - disponibleActual;
            producto.setActual(0);
            producto.setBodega(disponibleBodega - faltante);
            observacion = "Salida usando inventario de bodega";
        }

        productoRepository.save(producto);

        // Registramos movimiento de SALIDA
        Movimiento salida = new Movimiento();
        salida.setTipoMovimiento("SALIDA");
        salida.setCantidad(cantidad);
        salida.setFechaHora(LocalDateTime.now());
        salida.setObservacion(observacion);
        salida.setProducto(producto);
        salida.setNombreProducto(producto.getNombre());
        salida.setUsuario(usuario);
        movimientoService.guardar(salida);

        // Despues de la salida, verificamos si hay que trasladar desde bodega
        verificarYTrasladarDesdeBodega(producto, usuario);

        // Verificamos si quedo sin existencias
        if (estaSinExistencias(producto)) {
            return "ALERTA: No hay productos en bodega. El producto esta sin existencias.";
        }

        return "Salida registrada correctamente";
    }

    // VALIDAR: ya existe este codigo? (evita duplicados)
    public boolean existeCodigo(String codigo, Long idProductoActual) {
        Optional<Producto> existente = productoRepository.findByCodigo(codigo);
        if (existente.isEmpty()) return false;
        return !existente.get().getIdProducto().equals(idProductoActual);
    }

    // BUSCAR POR ID
    public Producto buscarPorId(Long id) {
        return productoRepository.findById(id).orElse(null);
    }

    // ELIMINAR PRODUCTO
    public void eliminar(Long id) {
        productoRepository.deleteById(id);
    }

    // LISTA SOLO LOS PRODUCTOS DE UNA CATEGORIA
    public List<Producto> listarPorCategoria(Integer idCategoria) {
        return productoRepository.findByCategoria_IdCategoria(idCategoria);
    }

    // LISTA SOLO LOS PRODUCTOS DE UN USUARIO
    public List<Producto> listarPorUsuario(Integer idUsuario) {
        return productoRepository.findByUsuario_IdUsuario(idUsuario);
    }

    // BUSCADOR: por nombre O codigo
    public List<Producto> buscar(String texto) {
        if (texto == null || texto.isBlank()) return listarTodos();
        return productoRepository.findByNombreContainingIgnoreCaseOrCodigoContainingIgnoreCase(texto.trim(), texto.trim());
    }

    // FILTRO POR ESTADO: Optimo / Stock bajo / Agotado
    public List<Producto> buscarPorEstado(String estado) {
        return productoRepository.findByEstado(estado);
    }

    // ALERTAS: productos con Actual MENOS DE 20 UNIDADES
    public List<Producto> listarProductosStockBajo() {
        return productoRepository.findByActualLessThan(20);
    }

    // NUEVO: productos completamente sin existencias (Actual = 0 Y Bodega = 0)
    public List<Producto> listarSinExistencias() {
        return productoRepository.findByActualAndBodega(0, 0);
    }

    // CONTAR TOTAL DE PRODUCTOS
    public long contarTodos() {
        return productoRepository.count();
    }
}