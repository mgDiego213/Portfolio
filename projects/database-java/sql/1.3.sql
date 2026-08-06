SELECT estado_cita, COUNT(id_cita) AS total_citas
FROM citas
GROUP BY estado_cita
ORDER BY total_citas DESC;