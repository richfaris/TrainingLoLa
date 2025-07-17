DROP PROCEDURE IF EXISTS build_range_measure;

CREATE PROCEDURE build_range_measure(
    IN p_measure_name VARCHAR(255),
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    CALL build_measure(p_measure_name, p_start_date, p_end_date);
END;
