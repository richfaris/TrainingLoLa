DROP PROCEDURE IF EXISTS update_readonly_permissions;

CREATE PROCEDURE update_readonly_permissions()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE view_name VARCHAR(255);
    DECLARE cur CURSOR FOR
        SELECT TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = SCHEMA() AND TABLE_NAME LIKE 'v\_%' or TABLE_NAME LIKE 'm\_%';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO view_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Construct and execute the GRANT statement
        SET @grant_statement = CONCAT("GRANT SELECT ON ", SCHEMA(), ".", view_name, " TO '", SCHEMA(), "_ro'@'%'");
        PREPARE stmt FROM @grant_statement;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;

    CLOSE cur;
END;
