DROP PROCEDURE IF EXISTS build_measure;

CREATE PROCEDURE build_measure(
    IN p_measure_name VARCHAR(255),
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    DECLARE v_table_name VARCHAR(255);
    DECLARE v_template_query TEXT;
    DECLARE v_exists INT DEFAULT 0;
    DECLARE v_future_dated INT DEFAULT 0;
    DECLARE v_date_built DATE;
    DECLARE v_date_drop_on DATE;
    DECLARE v_message TEXT;
    DECLARE v_user_built VARCHAR(255);
    DECLARE v_start_time DECIMAL(16,4);
    DECLARE v_end_time DECIMAL(16, 4);
    DECLARE v_seconds_to_build DECIMAL(12,4);
    DECLARE v_built_rows BIGINT;
    DECLARE v_built_size BIGINT;
    DECLARE v_measure_type VARCHAR(10);
    DECLARE v_valid_measure_names TEXT;

    -- Capture the username of the current session
    SET v_user_built = USER();

    -- Determine measure type
    SET v_measure_type = IF(p_start_date IS NULL, 'asof', 'range');

    -- Format the table name
    SET v_table_name = CONCAT('m_', p_measure_name, '_',
                              IF(v_measure_type = 'range', DATE_FORMAT(p_start_date, '%Y%m%d_'), ''),
                              DATE_FORMAT(p_end_date, '%Y%m%d'));

    -- Check if the measure already exists in v_built_measures
    SELECT COUNT(*), future_dated INTO v_exists, v_future_dated FROM v_built_measures WHERE built_name = v_table_name;

    -- If the measure exists, set return message
    IF v_exists > 0 AND NOT v_future_dated THEN
        SET v_message = CONCAT('The measure ', v_table_name, ' already exists.');
    END IF;

    IF v_message IS NULL THEN
        -- Get the template query
        SELECT VIEW_DEFINITION
        INTO v_template_query
        FROM INFORMATION_SCHEMA.VIEWS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = CONCAT('t_', p_measure_name);

        -- Check if the template exists
        IF v_template_query IS NULL THEN
            -- List valid measure names
            SELECT GROUP_CONCAT(SUBSTRING_INDEX(view_name, '_', -1)) INTO v_valid_measure_names
            FROM information_schema.views
            WHERE table_schema = DATABASE() AND view_name LIKE 't\_%' ;

            SET v_message = CONCAT('The measure name provided is not valid. Valid measure names are: ', v_valid_measure_names);
        END IF;
    END IF;

    IF v_message IS NULL THEN
        -- Check if the template is appropriate for the measure type
        IF v_measure_type = 'asof' AND v_template_query NOT LIKE '%<<$AsOfDate>>%' THEN
            SET v_message = 'This measure is configured for range, use build_range_measure instead of build_asof_measure.';
        ELSEIF v_measure_type = 'range' AND v_template_query NOT LIKE '%<<$StartDate>>%' THEN
            SET v_message = 'This measure is configured for as-of, use build_asof_measure instead of build_range_measure.';
        END IF;
    END IF;

    IF v_message IS NULL THEN
        -- Start timing
        SET v_start_time = unix_timestamp(curtime(4));

        -- Replace placeholders with actual dates
        IF v_measure_type = 'asof' THEN
            SET v_template_query = REPLACE(v_template_query, '<<$AsOfDate>>', p_end_date);
        ELSE
            SET v_template_query = REPLACE(REPLACE(v_template_query, '<<$StartDate>>', p_start_date), '<<$EndDate>>', p_end_date);
        END IF;

        -- Drop existing future_dated table
        IF v_future_dated THEN
            SET @drop_table = CONCAT('DROP TABLE ', v_table_name);
            PREPARE stmt FROM @drop_table;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END IF;

        -- Set isolation level to prevent locks
        SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
        START TRANSACTION;

        -- Create the table
        SET @create_table = CONCAT('CREATE TABLE ',
                            v_table_name,
                            ' CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci AS ',
                            v_template_query);
        PREPARE stmt FROM @create_table;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        COMMIT;

        -- End timing
        SET v_end_time = unix_timestamp(curtime(4));
        SET v_seconds_to_build = v_end_time - v_start_time;

        /*
        -- Grant SELECT privilege to schema()_ro@%
        SET @grant_statement = CONCAT("GRANT SELECT ON ", SCHEMA(), ".", v_table_name, " TO '", SCHEMA(), "_ro'@'%'");
        PREPARE stmt FROM @grant_statement;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        */

        -- Calculate date_drop_on based on build time
        SET v_date_drop_on = CURDATE() + INTERVAL ceil(v_seconds_to_build / 10) DAY;

        -- Update table COMMENT with metadata json
        SET @comment = CONCAT("ALTER TABLE ", v_table_name, " COMMENT = '{",
                              '"name": "', p_measure_name,
                              '", "type": "', v_measure_type,
                              '", "start_date": "', coalesce(p_start_date, p_end_date),
                              '", "end_date": "', p_end_date,
                              '", "sql_builder": "', v_user_built,
                              '", "build_secs": ', v_seconds_to_build,
                              ', "api_builder": null, "last_accessed": null, "last_api_user": null}', "'");
        PREPARE stmt FROM @comment;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        -- Set Isolation Level back for the session
        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

        SET v_message = CONCAT('Table ', v_table_name, ' has been successfully created in ', v_seconds_to_build, ' seconds.');
    END IF;

    SELECT v_message AS message;
END;
