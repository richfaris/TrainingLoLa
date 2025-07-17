DROP FUNCTION IF EXISTS bc_count_str;

CREATE FUNCTION bc_count_str(str TEXT, count_str VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE str_count INT;

  SET str_count = CHAR_LENGTH(str) - CHAR_LENGTH(REPLACE(str, count_str, SPACE(LENGTH(count_str)-1)));

  RETURN str_count;
END;
