public class Salon {
    // Atributo para almacenar el nombre del salón
    private String nombre;
    // Constructor para inicializar un salón con el nombre proporcionado
    public Salon(String nombre) {
        this.nombre = nombre;
    }
    // Métodos getter y setter para acceder y modificar el nombre del salón
    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}
