DELIMITER //

CREATE TRIGGER tr_consultorio_control
BEFORE INSERT ON consultorios
FOR EACH ROW
BEGIN
    -- Verificar si ya existe un consultorio en la misma ubicación y número
    IF EXISTS (SELECT 1 FROM consultorios WHERE ubicacion = NEW.ubicacion AND numero = NEW.numero) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Consultorio duplicado en la misma ubicación.';
    END IF;
END //

DELIMITER ;