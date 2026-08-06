DELIMITER //

CREATE TRIGGER tr_seguimiento_paciente
AFTER INSERT ON citas
FOR EACH ROW
BEGIN
    -- Insertar en la tabla seguimiento_paciente al registrar una nueva cita
    INSERT INTO seguimiento_paciente (id_paciente, nombre_paciente, fecha_hora)
    SELECT p.id_paciente, p.nombre, NOW()
    FROM pacientes p
    WHERE p.id_paciente = NEW.id_paciente;
END //

DELIMITER ;