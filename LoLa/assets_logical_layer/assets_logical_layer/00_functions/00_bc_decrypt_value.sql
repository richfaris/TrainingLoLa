/* bc_decrypt_value function
   used by views to allow certain carriers to access PII columns

   must be configured first by passing "Configure|KRYPT_KEY" as the parameter and storing
   the returned encrypted key in custom_data table in the value field under the name "lola_bc_decrypt_value"

   This routine logic is not accessible via SQLRunner so should be okay, but technically, if a carrier has direct DB
   access AND has bc_decrypt_value Configured for them by BC staff, AND their db user has SHOW_ROUTINE,
   they could show create function bc_decrypt_value and see the approach to restore the actual krypt_key
   and some internals of how BC encryption works.

   That is to say, we should work to remove SQL DB access from carriers, OR if they have it, just ENSURE
   that whatever user they are using does not have ability to SHOW CREATE FUNCTION (which should be the case)
   prior to configuring bc_decrypt_value for them.
*/
DROP FUNCTION IF EXISTS bc_decrypt_value;

CREATE FUNCTION bc_decrypt_value(encrypted_value TEXT)
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE enc_key BINARY(32);          -- Fixed 32 bytes for SHA-256 hash
    DECLARE data_type VARCHAR(20);
    DECLARE iv_and_data VARBINARY(2048); -- IV + ciphertext (max 2032 bytes ciphertext)
    DECLARE ciphertext VARBINARY(2032);  -- Max encrypted data size
    DECLARE decrypted_value VARBINARY(2048);
    DECLARE iv BINARY(16);
    DECLARE last_block BINARY(16);
    DECLARE const_one CHAR(32) DEFAULT 'bdAuQ8sCEk3qveBrmic8eKkeQ6YeKQF4';
    DECLARE const_two CHAR(32) DEFAULT 'hHSQwQqD3wCEb3XaR1eeSajxvInEenEm';

    -- Set encryption mode
    SET @@SESSION.block_encryption_mode = 'aes-256-cbc';

    -- Handle empty or invalid input
    IF COALESCE(encrypted_value, '') = '' THEN
        RETURN NULL;
    END IF;

    -- Handle Configure pattern
    IF LEFT(encrypted_value, 10) = 'Configure|' THEN
        RETURN TO_BASE64(
            AES_ENCRYPT(
                SUBSTRING(encrypted_value, 11),
                RIGHT(SHA2(const_one, 256), 32),
                LEFT(SHA2(const_two, 256), 16)
            )
        );
    END IF;

    -- Validate Encrypted pattern
    IF LEFT(encrypted_value, 11) != 'Encrypted |' THEN
        RETURN 'Invalid value to decrypt';
    END IF;

    -- Retrieve encryption key
    SELECT UNHEX(SHA2(
        AES_DECRYPT(
            FROM_BASE64(cd.value),
            RIGHT(SHA2(const_one, 256), 32),
            LEFT(SHA2(const_two, 256), 16)
        ), 256))
    INTO enc_key
    FROM custom_data cd
    WHERE name = 'lola_bc_decrypt_value'
    LIMIT 1;

    IF enc_key IS NULL THEN
        RETURN 'Encrypted';
    END IF;

    -- Extract data type and cipher text
    SET data_type = SUBSTRING_INDEX(SUBSTRING_INDEX(encrypted_value, '|', 2), '|', -1);
    SET iv_and_data = FROM_BASE64(SUBSTRING_INDEX(SUBSTRING_INDEX(encrypted_value, '|', 4), '|', -1));
    SET iv = SUBSTRING(iv_and_data, 1, 16);
    SET ciphertext = SUBSTRING(iv_and_data, 17);

    -- Prepare the last block for IV of the dummy block
    SET last_block = SUBSTRING(ciphertext, LENGTH(ciphertext) - 15, 16);
    IF LENGTH(ciphertext) < 16 THEN
        SET last_block = iv;  -- Fallback for short ciphertexts
    END IF;

    -- Decrypt with appended dummy block
    SET decrypted_value = AES_DECRYPT(
        UNHEX(
            CONCAT(
                HEX(ciphertext),
                SUBSTRING(
                    HEX(
                        AES_ENCRYPT(
                            '',  -- Empty string, padded by MySQL
                            enc_key,
                            last_block
                        )
                    ), 1, 32
                )
            )
        ),
        enc_key,
        iv
    );

    -- Handle decryption failure
    IF decrypted_value IS NULL THEN
        RETURN CONCAT('Decryption failed - ciphertext length: ', LENGTH(ciphertext));
    END IF;

    -- Strip '*' padding from the end only
    SET decrypted_value = TRIM(TRAILING '*' FROM CAST(decrypted_value AS CHAR));

    -- Cast based on data type
    CASE data_type
        WHEN 'date' THEN RETURN CAST(decrypted_value AS DATE);
        WHEN 'datetime' THEN RETURN CAST(decrypted_value AS DATETIME);
        WHEN 'int' THEN RETURN CAST(decrypted_value AS UNSIGNED);
        WHEN 'Decimal' THEN RETURN CAST(decrypted_value AS DECIMAL(22, 8));
        -- json / str
        ELSE RETURN CAST(decrypted_value AS CHAR);
    END CASE;
END;
