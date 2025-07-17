DROP FUNCTION IF EXISTS bc_ordinal;

CREATE FUNCTION bc_ordinal(number INT)
RETURNS VARCHAR(12)
DETERMINISTIC
BEGIN
  DECLARE ord VARCHAR(12);
  SET ord = (SELECT CONCAT(number, CASE
    WHEN number%100 BETWEEN 11 AND 13 THEN "th"
    WHEN number%10 = 1 THEN "st"
    WHEN number%10 = 2 THEN "nd"
    WHEN number%10 = 3 THEN "rd"
    ELSE "th"
  END));
  RETURN ord;
END;
