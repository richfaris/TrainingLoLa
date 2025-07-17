DROP PROCEDURE IF EXISTS build_asof_measure;

CREATE PROCEDURE build_asof_measure(
    IN p_measure_name VARCHAR(255),
    IN p_asof_date DATE
)
BEGIN
    CALL build_measure(p_measure_name, NULL, p_asof_date);
END;
