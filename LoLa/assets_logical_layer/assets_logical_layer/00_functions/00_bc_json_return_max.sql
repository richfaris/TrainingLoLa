DROP FUNCTION IF EXISTS bc_json_return_max;

CREATE FUNCTION bc_json_return_max(json_text TEXT, str_keys VARCHAR(255))
RETURNS TEXT DETERMINISTIC
CONTAINS SQL
BEGIN
    DECLARE max_total DECIMAL(10,2) DEFAULT 0;
    DECLARE current_total DECIMAL(10,2);
    DECLARE i INT DEFAULT 0;
    DECLARE json_length INT;
    DECLARE max_index INT DEFAULT -1;
    DECLARE temp_value DECIMAL(10,2);
    DECLARE key_array VARCHAR(1000);
    DECLARE key_count INT;
    DECLARE key_index INT;

    -- Split str_keys into an array
    SET key_array = REPLACE(str_keys, ',', '|');
    SET key_count = (LENGTH(key_array) - LENGTH(REPLACE(key_array, '|', ''))) + 1;

    -- Get the length of the JSON array
    SET json_length = JSON_LENGTH(json_text);

    -- Loop through each JSON object in the array
    WHILE i < json_length DO
        SET current_total = 0;
        SET key_index = 1;

        -- Loop through each key
        WHILE key_index <= key_count DO
            SET temp_value = COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(json_text, CONCAT('$[', i, '].', SUBSTRING_INDEX(SUBSTRING_INDEX(key_array, '|', key_index), '|', -1)))) AS DECIMAL(10,2)), 0);
            SET current_total = current_total + temp_value;
            SET key_index = key_index + 1;
        END WHILE;

        -- Check if this is the new max
        IF current_total > max_total THEN
            SET max_total = current_total;
            SET max_index = i;
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Return the JSON object with the max total
    IF max_index >= 0 THEN
        RETURN JSON_EXTRACT(json_text, CONCAT('$[', max_index, ']'));
    ELSE
        RETURN '{}';  -- Return an empty JSON object if no valid max found
    END IF;
END;
