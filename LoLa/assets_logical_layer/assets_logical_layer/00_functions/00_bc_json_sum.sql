DROP FUNCTION IF EXISTS bc_json_sum;

CREATE FUNCTION bc_json_sum(json_text TEXT, key_name VARCHAR(255))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE sum_value DECIMAL(12,2) DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE json_length INT;
    DECLARE temp_value DECIMAL(12,2);

    -- Get the length of the JSON array directly from the text
    SET json_length = JSON_LENGTH(json_text);

    -- Loop through each JSON object in the array
    WHILE i < json_length DO
        SET temp_value = COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(json_text, CONCAT('$[', i, '].', key_name))) AS DECIMAL(12,2)), 0);
        SET sum_value = sum_value + temp_value;
        SET i = i + 1;
    END WHILE;

    RETURN sum_value;
END;
