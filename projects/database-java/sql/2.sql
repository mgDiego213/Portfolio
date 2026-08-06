DELIMITER //

CREATE PROCEDURE calcular_pagos_diarios(IN fecha DATE)
BEGIN
    -- Seleccionar los pagos de la fecha específica
    SELECT id_pago, id_cita, monto, fecha, metodo_pago
    FROM pagos
    WHERE CAST(fecha AS DATE) = fecha;

    -- Calcular la suma total de los pagos en esa fecha
    SELECT SUM(monto) AS total_pagos
    FROM pagos
    WHERE CAST(fecha AS DATE) = fecha;
END //

DELIMITER ;
CALL calcular_pagos_diarios('2024-09-30');