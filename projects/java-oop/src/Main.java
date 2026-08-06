// Importación de clases necesarias para manejar listas, entrada de usuario y otros utilidades
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
// Definición de la clase principal del programa
public class Main {
    // Declaración de listas para almacenar objetos de Profesores, Alumnos, Materias, Cursos y Salones
    private static List<Profesor> profesores = new ArrayList<>();
    private static List<Alumno> alumnos = new ArrayList<>();
    private static List<Materia> materias = new ArrayList<>();
    private static List<Curso> cursos = new ArrayList<>();
    private static List<Salon> salones = new ArrayList<>();
    // Método principal del programa que ejecuta el bucle de menú principal
    public static void main(String[] args) {
        // Creación del objeto Scanner para leer la entrada del usuario
        Scanner scanner = new Scanner(System.in);
        // Bucle infinito para mantener el programa ejecutándose hasta que el usuario decida salir
        while (true) {
            // Muestra las opciones disponibles al usuario
            System.out.println("Selecciona una opción:");
            System.out.println("1. Agregar Profesor");
            System.out.println("2. Agregar Alumno");
            System.out.println("3. Agregar Materia");
            System.out.println("4. Agregar Curso");
            System.out.println("5. Buscar Profesor por Nombre");
            // Continuación de la muestra de opciones al usuario
            System.out.println("6. Buscar Alumno por Nombre");
            System.out.println("7. Salir");
            System.out.println("8. Agregar Salón");
            System.out.println("9. Asignar Calificación a Alumno en una Materia");
            // Finaliza la muestra de opciones y captura la opción seleccionada por el usuario
            System.out.println("10. Modificar Calificación de Alumno en una Materia");
            System.out.print("Opción: ");
            int opcion = scanner.nextInt();
            scanner.nextLine(); // Limpia el buffer del scanner
            // Estructura switch para manejar las opciones seleccionadas por el usuario
            switch (opcion) {
                case 1:
                    agregarProfesor(scanner); // Llama al método para agregar un profesor
                    break;
                case 2:
                    agregarAlumno(scanner); // Llama al método para agregar un alumno
                    break;
                case 3:
                    agregarMateria(scanner); // Llama al método para agregar una materia
                    break;
                case 4:
                    agregarCurso(scanner); // Llama al método para agregar un curso
                    break;
                case 5:
                    buscarYMostrarProfesor(scanner); // Llama al método para buscar y mostrar un profesor por nombre
                    break;
                case 6:
                    buscarYMostrarAlumno(scanner); // Llama al método para buscar y mostrar un alumno por nombre
                    break;
                case 7:
                    System.out.println("Saliendo..."); // Imprime mensaje de salida
                    System.exit(0); // Termina la ejecución del programa
                    break;
                case 8:
                    agregarSalon(scanner); // Llama al método para agregar un salón
                    break;
                case 9:
                    asignarCalificacion(scanner); // Llama al método para asignar una calificación a un alumno en una materia
                    break;
                case 10:
                    modificarCalificacion(scanner); // Llama al método para modificar la calificación de un alumno en una materia
                    break;
                default:
                    System.out.println("Opción no válida."); // Maneja la selección de una opción no válida
                    break;
            }
        }
    }
    // Método para agregar un salón, solicitando el nombre del salón al usuario
    private static void agregarSalon(Scanner scanner) {
        System.out.print("Nombre del Salón: ");
        String nombreSalon = scanner.nextLine();
        Salon salon = new Salon(nombreSalon); // Crea una instancia de Salón con el nombre proporcionado
        salones.add(salon); // Añade el salón creado a la lista de salones
        System.out.println("Salón agregado exitosamente."); // Confirma la adición del salón
    }
    // Método para asignar una calificación a un alumno en una materia específica
    private static void asignarCalificacion(Scanner scanner) {
        System.out.print("Nombre del Alumno: ");
        String nombreAlumno = scanner.nextLine();
        Alumno alumno = buscarAlumnoPorNombre(nombreAlumno); // Busca el alumno por nombre
        if (alumno == null) {
            System.out.println("Alumno no encontrado."); // Maneja el caso de no encontrar el alumno
            return;
        }
        System.out.print("Nombre de la Materia: ");
        String nombreMateria = scanner.nextLine();
        Materia materia = buscarMateriaPorNombre(nombreMateria); // Busca la materia por nombre
        if (materia == null) {
            System.out.println("Materia no encontrada."); // Maneja el caso de no encontrar la materia
            return;
        }
        System.out.print("Calificación: ");
        double calificacion = scanner.nextDouble(); // Captura la calificación a asignar
        scanner.nextLine(); // Limpia el buffer del scanner
        materia.asignarCalificacion(alumno, calificacion); // Asigna la calificación al alumno en la materia
        System.out.println("Calificación asignada exitosamente."); // Confirma la asignación de la calificación
    }
    // Método para modificar la calificación de un alumno en una materia específica
    private static void modificarCalificacion(Scanner scanner) {
        System.out.print("Nombre del Alumno para modificar calificación: ");
        String nombreAlumno = scanner.nextLine();
        Alumno alumno = buscarAlumnoPorNombre(nombreAlumno); // Busca el alumno por nombre
        if (alumno == null) {
            System.out.println("Alumno no encontrado."); // Maneja el caso de no encontrar el alumno
            return;
        }
        System.out.print("Nombre de la Materia de la calificación a modificar: ");
        String nombreMateria = scanner.nextLine();
        Materia materia = buscarMateriaPorNombre(nombreMateria); // Busca la materia por nombre
        if (materia == null) {
            System.out.println("Materia no encontrada."); // Maneja el caso de no encontrar la materia
            return;
        }
        System.out.print("Nueva Calificación: ");
        double nuevaCalificacion = scanner.nextDouble(); // Captura la nueva calificación a asignar
        scanner.nextLine(); // Limpia el buffer del scanner
        materia.modificarCalificacion(alumno, nuevaCalificacion); // Modifica la calificación del alumno en la materia
        System.out.println("Calificación modificada exitosamente."); // Confirma la modificación de la calificación
    }
    // Método para agregar un profesor, solicitando datos como nombre, nómina, sueldo por hora y materia
    private static void agregarProfesor(Scanner scanner) {
        System.out.print("Nombre: ");
        String nombre = scanner.nextLine();
        System.out.print("Número de nómina: ");
        int numeroNomina = scanner.nextInt(); // Captura el número de nómina del profesor
        System.out.print("Sueldo por hora: ");
        double sueldoPorHora = scanner.nextDouble(); // Captura el sueldo por hora del profesor
        scanner.nextLine(); // Limpia el buffer del scanner
        System.out.print("Nombre de la Materia: ");
        String nombreMateria = scanner.nextLine();
        Materia materia = buscarMateriaPorNombre(nombreMateria); // Busca la materia por nombre
        if (materia == null) {
            System.out.println("Materia no encontrada, creando una nueva..."); // Maneja el caso de no encontrar la materia
        }
        Profesor profesor = new Profesor(nombre, numeroNomina, sueldoPorHora, materia); // Crea una instancia de Profesor con los datos proporcionados
        profesores.add(profesor); // Añade el profesor creado a la lista de profesores
        System.out.println("Profesor agregado exitosamente."); // Confirma la adición del profesor
    }
    // Método para buscar y mostrar los datos de un profesor por nombre
    private static void buscarYMostrarProfesor(Scanner scanner) {
        System.out.print("Nombre del Profesor a buscar: ");
        String nombre = scanner.nextLine();
        Profesor profesor = buscarProfesorPorNombre(nombre); // Busca el profesor por nombre
        if (profesor != null) {
            // Imprime los datos del profesor encontrado
            System.out.println("Profesor encontrado:");
            System.out.println("Nombre: " + profesor.getNombre());
            System.out.println("Número de Nómina: " + profesor.getNumeroNomina());
            System.out.println("Sueldo por Hora: " + profesor.getSueldoPorHora());
            System.out.println("Materia: " + profesor.getMateria().getNombre());
        } else {
            System.out.println("Profesor no encontrado."); // Maneja el caso de no encontrar el profesor
        }
    }
    // Método para agregar un alumno, solicitando datos como matrícula, nombre, edad y curso
    private static void agregarAlumno(Scanner scanner) {
        System.out.print("Matrícula: ");
        String matricula = scanner.nextLine();
        System.out.print("Nombre: ");
        String nombre = scanner.nextLine();
        System.out.print("Edad: ");
        int edad = scanner.nextInt(); // Captura la edad del alumno
        scanner.nextLine(); // Limpia el buffer del scanner
        System.out.print("Nombre del Curso: ");
        String nombreCurso = scanner.nextLine();
        Curso curso = buscarCursoPorNombre(nombreCurso); // Busca el curso por nombre
        if (curso == null) {
            System.out.println("Curso no encontrado, por favor crea el curso primero."); // Maneja el caso de no encontrar el curso
            return;
        }
        Alumno alumno = new Alumno(matricula, nombre, edad, curso); // Crea una instancia de Alumno con los datos proporcionados
        alumnos.add(alumno); // Añade el alumno creado a la lista de alumnos
        System.out.println("Alumno agregado exitosamente."); // Confirma la adición del alumno
    }
    // Método para agregar una materia, solicitando datos como nombre, clave, número de créditos, cantidad de horas y salón
    private static void agregarMateria(Scanner scanner) {
        System.out.print("Nombre: ");
        String nombre = scanner.nextLine();
        System.out.print("Clave: ");
        String clave = scanner.nextLine();
        System.out.print("Número de Créditos: ");
        int numeroCreditos = scanner.nextInt(); // Captura el número de créditos de la materia
        System.out.print("Cantidad de Horas: ");
        int cantidadHoras = scanner.nextInt(); // Captura la cantidad de horas semanales de la materia
        scanner.nextLine(); // Limpia el buffer del scanner
        System.out.print("Nombre del Salón: ");
        String nombreSalon = scanner.nextLine();
        Salon salon = buscarSalonPorNombre(nombreSalon); // Busca el salón por nombre
        if (salon == null) {
            System.out.println("Salón no encontrado, por favor crea el salón primero."); // Maneja el caso de no encontrar el salón
            return;
        }
        Materia materia = new Materia(nombre, clave, numeroCreditos, cantidadHoras, salon); // Crea una instancia de Materia con los datos proporcionados
        materias.add(materia); // Añade la materia creada a la lista de materias
        System.out.println("Materia agregada exitosamente."); // Confirma la adición de la materia
    }
    // Método para buscar un salón por nombre dentro de la lista de salones y devolver el objeto Salón correspondiente
    public static Salon buscarSalonPorNombre(String nombre) {
        for (Salon salon : salones) {
            if (salon.getNombre().equalsIgnoreCase(nombre)) {
                return salon; // Devuelve el salón encontrado
            }
        }
        return null; // Devuelve null si no se encuentra el salón
    }
    // Método para agregar un curso, solicitando el nombre del curso al usuario
    private static void agregarCurso(Scanner scanner) {
        System.out.print("Nombre del Curso: ");
        String nombreCurso = scanner.nextLine();
        Curso curso = new Curso(nombreCurso); // Crea una instancia de Curso con el nombre proporcionado
        cursos.add(curso); // Añade el curso creado a la lista de cursos
        System.out.println("Curso agregado exitosamente."); // Confirma la adición del curso
        boolean agregarMateria = true; // Inicializa la variable para controlar la adición de materias al curso
        while (agregarMateria) {
            // Solicita al usuario si desea añadir una materia al curso
            System.out.print("¿Deseas añadir una materia al curso? (s/n): ");
            String respuesta = scanner.nextLine();
            if (respuesta.equalsIgnoreCase("s")) {
                System.out.print("Nombre de la Materia: ");
                String nombreMateria = scanner.nextLine();
                Materia materia = buscarMateriaPorNombre(nombreMateria); // Busca la materia por nombre
                if (materia != null) {
                    curso.addMateria(materia); // Añade la materia al curso si se encuentra
                    System.out.println("Materia añadida al curso.");
                } else {
                    System.out.println("Materia no encontrada."); // Maneja el caso de no encontrar la materia
                }
            } else {
                agregarMateria = false; // Finaliza el bucle si el usuario no desea añadir más materias
            }
        }
    }
    // Método para buscar y mostrar los datos de un alumno por nombre
    private static void buscarYMostrarAlumno(Scanner scanner) {
        System.out.print("Nombre del Alumno a buscar: ");
        String nombre = scanner.nextLine();
        Alumno alumno = buscarAlumnoPorNombre(nombre); // Busca el alumno por nombre
        if (alumno != null) {
            // Imprime los datos del alumno encontrado
            System.out.println("Alumno encontrado: " + alumno.getNombre());
            System.out.println("Matrícula: " + alumno.getMatricula());
            System.out.println("Edad: " + alumno.getEdad());
            System.out.println("Curso: " + alumno.getCurso().getNombre());
            if (!alumno.getCurso().getMaterias().isEmpty()) {
                Materia primeraMateria = alumno.getCurso().getMaterias().get(0);
                Salon salon = primeraMateria.getSalon();
                if (salon != null) {
                    System.out.println("Salon: " + salon.getNombre()); // Muestra el salón de la primera materia si existe
                } else {
                    System.out.println("Salon: No asignado"); // Indica que no hay salón asignado si no se encuentra
                }
            } else {
                System.out.println("El alumno no tiene materias asignadas."); // Maneja el caso de un alumno sin materias asignadas
            }
        } else {
            System.out.println("Alumno no encontrado."); // Maneja el caso de no encontrar el alumno
        }
    }
    // Método para buscar un profesor por nombre dentro de la lista de profesores y devolver el objeto Profesor correspondiente
    public static Profesor buscarProfesorPorNombre(String nombre) {
        for (Profesor profesor : profesores) {
            if (profesor.getNombre().equalsIgnoreCase(nombre)) {
                return profesor; // Devuelve el profesor encontrado
            }
        }
        return null; // Devuelve null si no se encuentra el profesor
    }
    // Método para buscar un alumno por nombre dentro de la lista de alumnos y devolver el objeto Alumno correspondiente
    public static Alumno buscarAlumnoPorNombre(String nombre) {
        for (Alumno alumno : alumnos) {
            if (alumno.getNombre().equalsIgnoreCase(nombre)) {
                return alumno; // Devuelve el alumno encontrado
            }
        }
        return null; // Devuelve null si no se encuentra el alumno
    }
    // Método para procesar una línea de texto, separarla por comas y crear o añadir objetos según el tipo indicado
    private static void procesarLinea(String linea) {
        String[] partes = linea.split(",");
        switch (partes[0]) {
            case "Profesor":
                Materia materia = buscarMateriaPorNombre(partes[4]);
                if (materia != null) {
                    // Crea y añade un nuevo profesor a la lista si se encuentra la materia
                    profesores.add(new Profesor(partes[1], Integer.parseInt(partes[2]), Double.parseDouble(partes[3]), materia));
                }
                break;
            case "Alumno":
                Curso curso = buscarCursoPorNombre(partes[4]);
                if (curso != null) {
                    // Crea y añade un nuevo alumno a la lista si se encuentra el curso
                    alumnos.add(new Alumno(partes[1], partes[2], Integer.parseInt(partes[3]), curso));
                }
                break;
            case "Materia":
                // Crea y añade una nueva materia a la lista con los datos proporcionados
                materias.add(new Materia(partes[1], partes[2], Integer.parseInt(partes[3]), Integer.parseInt(partes[4])));
                break;
            case "Curso":
                // Crea y añade un nuevo curso a la lista con el nombre proporcionado
                cursos.add(new Curso(partes[1]));
                break;
        }
    }
    // Método para buscar una materia por nombre dentro de la lista de materias y devolver el objeto Materia correspondiente
    private static Materia buscarMateriaPorNombre(String nombre) {
        for (Materia materia : materias) {
            if (materia.getNombre().equalsIgnoreCase(nombre)) {
                return materia; // Devuelve la materia encontrada
            }
        }
        return null; // Devuelve null si no se encuentra la materia
    }
    // Método para buscar un curso por nombre dentro de la lista de cursos y devolver el objeto Curso correspondiente
    private static Curso buscarCursoPorNombre(String nombre) {
        for (Curso curso : cursos) {
            if (curso.getNombre().equalsIgnoreCase(nombre)) {
                return curso; // Devuelve el curso encontrado
            }
        }
        return null; // Devuelve null si no se encuentra el curso
    }
}
