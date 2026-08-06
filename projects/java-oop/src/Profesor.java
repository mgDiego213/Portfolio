public class Profesor {
    // Atributos para almacenar información del profesor
    private String nombre;
    private int numeroNomina;
    private double sueldoPorHora;
    private Materia materia;
    // Constructor para inicializar un objeto Profesor con los datos proporcionados
    public Profesor(String nombre, int numeroNomina, double sueldoPorHora, Materia materia) {
        this.nombre = nombre;
        this.numeroNomina = numeroNomina;
        this.sueldoPorHora = sueldoPorHora;
        this.materia = materia;
    }
    // Métodos getter y setter para acceder y modificar los atributos del profesor
    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    public int getNumeroNomina() {
        return numeroNomina;
    }
    public void setNumeroNomina(int numeroNomina) {
        this.numeroNomina = numeroNomina;
    }
    public double getSueldoPorHora() {
        return sueldoPorHora;
    }
    public void setSueldoPorHora(double sueldoPorHora) {
        this.sueldoPorHora = sueldoPorHora;
    }
    public Materia getMateria() {
        return materia;
    }
    public void setMateria(Materia materia) {
        this.materia = materia;
    }
}
