import java.util.HashMap;
import java.util.Map;
public class Calificacion {
    // Atributos para asociar una materia con las calificaciones de los alumnos
    private Materia materia;
    private Map<String, Double> calificacionesPorAlumno = new HashMap<>();
    // Constructor para inicializar el objeto Calificacion con la materia asociada
    public Calificacion(Materia materia) {
        this.materia = materia;
    }
    // Métodos para asignar y obtener calificaciones de los alumnos en la materia
    public void asignarCalificacion(Alumno alumno, double calificacion) {
        calificacionesPorAlumno.put(alumno.getMatricula(), calificacion);
    }
    public Double obtenerCalificacion(Alumno alumno) {
        return calificacionesPorAlumno.get(alumno.getMatricula());
    }
}
