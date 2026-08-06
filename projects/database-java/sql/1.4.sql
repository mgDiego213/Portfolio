SELECT id_cita, fecha_hora, id_paciente, id_medico
FROM citas
WHERE fecha_hora >= DATE_ADD(CURDATE(), INTERVAL -23 DAY)
ORDER BY fecha_hora DESC;