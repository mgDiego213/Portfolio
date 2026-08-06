import java.util.ArrayList;
public class Curso {
    // Atributos para almacenar el nombre del curso y la lista de materias asociadas
    private String nombre;
    private ArrayList<Materia> materias = new ArrayList<>();
    // Constructor para inicializar un curso con el nombre proporcionado
    public Curso(String nombre) {
        this.nombre = nombre;
    }
    // Método para añadir materias al curso, con restricción en la cantidad de materias
    public void addMateria(Materia materia) {
        if (materias.size() < 3) {
            materias.add(materia);
        } else {
            System.out.println("No se pueden añadir más de 3 materias a un curso.");
        }
    }
    // Métodos getter y setter para acceder y modificar los atributos del curso
    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    public ArrayList<Materia> getMaterias() {
        return materias;
    }
    public void setMaterias(ArrayList<Materia> materias) {
        this.materias = materias;
    }
}
