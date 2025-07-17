DROP PROCEDURE IF EXISTS drop_measure_on;

CREATE PROCEDURE drop_measure_on(
    IN p_table_name VARCHAR(255),
    IN p_drop_date DATE
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE v_message TEXT;

    -- Check if the measure exists in u_built_measures
    SELECT COUNT(*)
    INTO v_exists
    FROM v_built_measures
    WHERE built_name = p_table_name;

    -- If the measure does not exist, return an error message
    IF v_exists = 0 THEN
        SET v_message = CONCAT('The measure ', p_table_name, ' does not exist in the system.');
        SELECT v_message AS message;
    ELSE
        -- ALTER TABLE COMMENT to set new date_drop_on
        UPDATE u_built_measures
        SET date_drop_on = QUOTE(p_drop_date)
        WHERE built_name = p_table_name;

        SET v_message = CONCAT('The drop date for measure ', p_table_name, ' has been updated to ', p_drop_date, '.');

        SELECT v_message AS message;
    END IF;
END;
