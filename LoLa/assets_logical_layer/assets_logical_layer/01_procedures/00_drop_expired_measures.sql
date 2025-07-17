DROP PROCEDURE IF EXISTS drop_expired_measures;

CREATE PROCEDURE drop_expired_measures()
BEGIN
    DECLARE v_table_name VARCHAR(255);
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR
        SELECT built_name
        FROM v_built_measures
        WHERE date_drop_on IS NOT NULL AND date_drop_on <= CURDATE();
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_table_name;
        IF v_done THEN
            LEAVE read_loop;
        END IF;

        SET @drop_statement = CONCAT('DROP TABLE IF EXISTS ', v_table_name);
        PREPARE stmt FROM @drop_statement;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

    END LOOP;

    CLOSE cur;
END;
