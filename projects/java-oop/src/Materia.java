import java.util.Map;
import java.util.HashMap;
public class Materia {
    // Atributos para almacenar información de la materia y las calificaciones de los alumnos
    private String nombre;
    private String clave;
    private int numeroCreditos;
    private int cantidadHoras;
    private Salon salon;
    private Map<String, Double> calificacionesPorAlumno = new HashMap<>();
    // Constructor para inicializar una materia con o sin salón asignado
    public Materia(String nombre, String clave, int numeroCreditos, int cantidadHoras, Salon salon) {
        this.nombre = nombre;
        this.clave = clave;
        this.numeroCreditos = numeroCreditos;
        this.cantidadHoras = cantidadHoras;
        this.salon = salon;
    }
    public Materia(String parte, String parte1, int numeroCreditos, int cantidadHoras) {
    }
    // Métodos para manejar las calificaciones de los alumnos en esta materia
    public void asignarCalificacion(Alumno alumno, double calificacion) {
        calificacionesPorAlumno.put(alumno.getMatricula(), calificacion);
    }
    public void modificarCalificacion(Alumno alumno, double calificacion) {
        asignarCalificacion(alumno, calificacion); // Reutiliza el método de asignar para modificar
    }
    // Métodos getter y setter para acceder y modificar los atributos de la materia
    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    public String getClave() {
        return clave;
    }
    public void setClave(String clave) {
        this.clave = clave;
    }
    public int getNumeroCreditos() {
        return numeroCreditos;
    }
    public void setNumeroCreditos(int numeroCreditos) {
        this.numeroCreditos = numeroCreditos;
    }
    public int getCantidadHoras() {
        return cantidadHoras;
    }
    public void setCantidadHoras(int cantidadHoras) {
        this.cantidadHoras = cantidadHoras;
    }
    public Salon getSalon() {
        return salon;
    }
    public void setSalon(Salon salon) {
        this.salon = salon;
    }
}