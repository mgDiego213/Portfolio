DELIMITER //

CREATE PROCEDURE reporte_pacientes_primer_trimestre()
BEGIN
    SELECT p.id_paciente, p.nombre, p.ap_paterno, COUNT(c.id_cita) AS citas_realizadas
    FROM pacientes p
    JOIN citas c ON p.id_paciente = c.id_paciente
    WHERE c.fecha_hora BETWEEN '2024-01-01' AND '2024-09-31'
    GROUP BY p.id_paciente, p.nombre, p.ap_paterno
    ORDER BY citas_realizadas DESC;
END //

DELIMITER ;
CALL reporte_pacientes_primer_trimestre();
