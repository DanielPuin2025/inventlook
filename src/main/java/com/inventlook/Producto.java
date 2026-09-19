package com.inventlook;
import jakarta.persistence.*;

@Entity
@Table(name = "producto")
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_producto")
    private Long idProducto;

    @Column(nullable = false, unique = true, length = 10)
    private String codigo;

    @Column(nullable = false, length = 100)
    private String nombre;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_categoria", nullable = true)
    private Categoria categoria;

    @ManyToOne
    @JoinColumn(name = "id_usuario", referencedColumnName = "id_usuario")
    private Usuario usuario;

    // NUEVOS CAMPOS: Actual (tienda) y Bodega
    @Column(nullable = false)
    private Integer actual = 0;

    @Column(nullable = false)
    private Integer bodega = 0;

    @Column(nullable = false, length = 20)
    private String estado = "Optimo";

    @Column(length = 100)
    private String proveedor;

    public Producto() {}

    // Actualiza el estado segun la suma de Actual + Bodega
    public void actualizarEstadoPorCantidad() {
        int total = actual + bodega;
        if (total <= 0) {
            this.estado = "Agotado";
        } else if (total >= 20) {
            this.estado = "Optimo";
        } else {
            this.estado = "Stock bajo";
        }
    }

    // Getters y Setters
    public Long getIdProducto() { return idProducto; }
    public void setIdProducto(Long idProducto) { this.idProducto = idProducto; }
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public Categoria getCategoria() { return categoria; }
    public void setCategoria(Categoria categoria) { this.categoria = categoria; }
    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    // Nuevos getters y setters para Actual
    public Integer getActual() { return actual; }
    public void setActual(Integer actual) {
        this.actual = actual;
        actualizarEstadoPorCantidad();
    }

    // Nuevos getters y setters para Bodega
    public Integer getBodega() { return bodega; }
    public void setBodega(Integer bodega) {
        this.bodega = bodega;
        actualizarEstadoPorCantidad();
    }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getProveedor() { return proveedor; }
    public void setProveedor(String proveedor) { this.proveedor = proveedor; }
}