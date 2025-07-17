DROP FUNCTION IF EXISTS bc_label_questions;

CREATE FUNCTION bc_label_questions(builder_obj TEXT)
RETURNS TEXT
READS SQL DATA
BEGIN
    DECLARE result TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE question_obj TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
    DECLARE question_ids TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
    DECLARE question_id CHAR(36);
    DECLARE num_questions INT;
    DECLARE num_answers INT;
    DECLARE answers_obj TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
    DECLARE answer_obj TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
    DECLARE answer TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
    DECLARE question_text VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
    DECLARE question_type VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

    IF builder_obj not like '%"questions": {"%' THEN
       RETURN NULL;
    END IF;

    SET question_obj = json_extract(builder_obj, '$.questions');
    SET question_ids = json_keys(question_obj);
    SET num_questions = json_length(question_ids);
    SET result = '{';
    WHILE i < num_questions DO
       SET question_id = substring_index(substring_index(question_ids, '"', (i + 1) * 2), '"', -1);
    -- nested substring_index about 6% faster than json funcs below, and safe to do in this context
    -- SET question_id = json_unquote(json_extract(question_ids, concat('$[', i, ']')));
      SELECT
        label, inputType
      INTO
        question_text, question_type
      FROM item_questions
      WHERE id = question_id;

      IF question_type is NULL THEN
        SET result = concat(result, json_quote(question_id), ': ');
      ELSE
        SET result = concat(result, json_quote(question_text), ': ');
      END IF;

      SET j = 0;
      SET answers_obj = json_extract(question_obj, concat('$."', question_id, '"'));
      SET num_answers = json_length(answers_obj);
      SET answer = '';
      WHILE j < num_answers DO
        SET answer_obj = json_extract(answers_obj, concat('$[', j, ']'));
        IF question_type = 'addtlInsured' THEN
          SET answer = concat(answer, json_unquote(json_extract(answer_obj, '$.contactInfo.name')));
        ELSEIF question_type = 'Address' THEN
          SET answer = concat(answer, concat_ws(', ',
             json_unquote(json_extract(answer_obj, '$.addressLine1')),
             nullif(json_unquote(json_extract(answer_obj, '$.addressLine2')), ''),
             json_unquote(json_extract(answer_obj, '$.addressCity')),
             concat(json_unquote(json_extract(answer_obj, '$.addressState')), ' ',
                    json_unquote(json_extract(answer_obj, '$.addressZip'))
                 )
               )
           );
        ELSEIF question_type = 'Contact' THEN
          SET answer = concat(answer, json_unquote(json_extract(answer_obj, '$.name')));
        ELSE
          SET answer = concat(answer, json_unquote(json_extract(answer_obj, '$.text')));
        END IF;
        SET j = j + 1;
        IF j < num_answers THEN
          SET answer = concat(answer, '; ');
        END IF;
      END WHILE;

      SET result = concat(result, json_quote(answer));
      SET i = i + 1;
      IF i < num_questions THEN
        SET result = concat(result, ', ');
      END IF;
    END WHILE;
    SET result = concat(result, '}');

    RETURN result;
END;
