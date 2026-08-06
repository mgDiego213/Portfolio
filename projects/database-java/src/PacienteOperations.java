import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;

public class PacienteOperations {

    // Crear un nuevo paciente
    public static void crearPaciente(String nombre, String apPaterno, String apMaterno,
                                     String fechaNacimiento, String correo, String historialMedico) {
        String query = "INSERT INTO pacientes (nombre, ap_paterno, ap_materno, fecha_nacimiento, correo, historial_medico) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, nombre);
            stmt.setString(2, apPaterno);
            stmt.setString(3, apMaterno);
            stmt.setString(4, fechaNacimiento);
            stmt.setString(5, correo);
            stmt.setString(6, historialMedico);
            stmt.executeUpdate();
            System.out.println("Paciente agregado exitosamente.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public static void obtenerPacientes() {
        String query = "SELECT * FROM pacientes";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id_paciente") +
                        ", Nombre: " + rs.getString("nombre") +
                        ", Apellido Paterno: " + rs.getString("ap_paterno") +
                        ", Fecha Nacimiento: " + rs.getDate("fecha_nacimiento") +
                        ", Correo: " + rs.getString("correo") +
                        ", Historial Médico: " + rs.getString("historial_medico"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public static void actualizarPaciente(int id, String nuevoNombre) {
        String query = "UPDATE pacientes SET nombre = ? WHERE id_paciente = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, nuevoNombre);
            stmt.setInt(2, id);
            stmt.executeUpdate();
            System.out.println("Paciente actualizado exitosamente.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public static void eliminarPaciente(int id) {
        String deletePagosQuery = "DELETE FROM pagos WHERE id_cita IN (SELECT id_cita FROM citas WHERE id_paciente = ?)";
        String deleteCitasQuery = "DELETE FROM citas WHERE id_paciente = ?";
        String deletePacienteQuery = "DELETE FROM pacientes WHERE id_paciente = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement deletePagosStmt = conn.prepareStatement(deletePagosQuery);
             PreparedStatement deleteCitasStmt = conn.prepareStatement(deleteCitasQuery);
             PreparedStatement deletePacienteStmt = conn.prepareStatement(deletePacienteQuery)) {

            // 1. Eliminar todos los pagos relacionados con las citas del paciente
            deletePagosStmt.setInt(1, id);
            deletePagosStmt.executeUpdate();

            // 2. Eliminar todas las citas asociadas al paciente
            deleteCitasStmt.setInt(1, id);
            deleteCitasStmt.executeUpdate();

            // 3. Eliminar el paciente
            deletePacienteStmt.setInt(1, id);
            deletePacienteStmt.executeUpdate();

            System.out.println("Paciente, sus citas y pagos asociados han sido eliminados exitosamente.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}