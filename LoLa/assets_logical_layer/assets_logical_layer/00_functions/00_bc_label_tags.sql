DROP FUNCTION IF EXISTS bc_label_tags;

CREATE FUNCTION bc_label_tags(system_tags_text TEXT)
RETURNS TEXT
READS SQL DATA
BEGIN
    DECLARE result TEXT;

    SET result = (
        SELECT
            CASE
                WHEN NULLIF(system_tags_text, '{}') IS NOT NULL THEN
                    CONCAT('{', COALESCE(
                        GROUP_CONCAT(
                            CONCAT('"', s.name, '": ', JSON_EXTRACT(system_tags_text, CONCAT('$."', s.id, '"')))
                            ORDER BY s.name SEPARATOR ', '
                        ),
                    ''), '}')
                ELSE NULL
            END
        FROM system_tags s
        WHERE system_tags_text LIKE CONCAT('%"', s.id, '": "%')
          AND system_tags_text NOT LIKE CONCAT('%"', s.id, '": ""%')
    );

    RETURN result;
END;
